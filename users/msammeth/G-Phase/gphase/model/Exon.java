 /*
 * Created on Mar 3, 2005
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package gphase.model;

import java.io.Serializable;
import java.util.Collection;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

/**
 * See <code>http://www.genomicglossaries.com/content/gene_def.asp</code>:
 * "What are the rules for deciding whether two partially overlapping mRNAs should be 
 * declared to be  alternative transcripts of the same gene or products of different genes? 
 * We have none."
 * <br><br>
 * Ensembl says in <code>http://whatislife.com/gene-definition.html</code>: 
 * A gene is a set of connected transcripts. A transcript is a set of exons via transcription 
 * followed (optionally) by pre-mRNA splicing. Two transcripts are connected if they share at 
 * least part of one exon in the genomic coordinates. At least one transcript must be expressed 
 * outside of the nucleus and one transcript must encode a protein (see footnotes).  
 * <br><br>
 * Hence, we (Sylvain, Tyler and me) define an exon to belong to strictly one gene.
 * <br><br>
 * 
 * 
 * @author micha
 */
public class Exon extends DirectedRegion {

	transient HashMap hitparade= null;	// do not serialize
	HashMap homologs= null;	// maps genes to exon homologs
							// also captures the alternatively spliced exon
							// in same gene for: a3, a5, me
	
	SuperExon superExon= null;
	SpliceSite donor= null;
	SpliceSite acceptor= null;
	HashMap phases= new HashMap();
	
		
	public boolean setPhase(Translation trans, Phase phas) {
		
		if (phases.get(trans)!= null) {
			System.out.println("Exon "+this+" already used in another phase by translation "+trans+"!");
			return false;
		}
		
		phases.put(trans, phas);
		return true;
	}
	
	/**
	 * returns hits to exons of all homolog genes
	 * @return
	 */
	public PWHit[] getHits() {
		
			// count values
		Object[] oa= hitparade.values().toArray();
		int size= 0;
		for (int i = 0; i < oa.length; i++) 
			size+= ((Vector) oa[i]).size();
		
		PWHit[] result= new PWHit[size];
		int x= 0;
		for (int i = 0; i < oa.length; i++) {
			Vector v= (Vector) oa[i];
			for (int j = 0; j < v.size(); j++) 
				result[x++]= (PWHit) v.elementAt(j);
		}
		
		return result;
	}
	
	public PWHit[] getHits(Gene g) {
		
		if (superExon!= null)
			return superExon.getHits(g);
		
		if (hitparade== null|| hitparade.get(g)== null)
			return null;
		
		Vector v= (Vector) hitparade.get(g);
		PWHit[] result= new PWHit[v.size()];
		for (int i = 0; i < result.length; i++) 
			result[i]= (PWHit) v.elementAt(i);
		
		return result;
	}
	
	public boolean removeHit(Gene g, PWHit h) {
	
		Vector v;
		if (hitparade== null|| (v= (Vector) hitparade.get(g))== null)
			return false;

		return v.remove(h);
	}
	
	public boolean removeTranscript(Transcript trans) {
		Transcript[] newTranscripts= new Transcript[transcripts.length- 1];
		int pos= 0;
		boolean flag= false;
		for (int i = 0; i < transcripts.length; i++) 
			if (transcripts[i]!= trans)
				newTranscripts[pos++]= transcripts[i];
			else
				flag= true;
		if (flag)
			transcripts= newTranscripts;
		return flag;
	}
	
	public boolean contains(Region anotherRegion) {

		if (!anotherRegion.getChromosome().equalsIgnoreCase(getChromosome()))
			return false;
		
		if ((getStart()<= anotherRegion.getStart())&& (getEnd()>= anotherRegion.getEnd()))
			return true;
		return false;
	}

	public boolean contains(int absPos) {
		
		if (absPos>= getStart()&& absPos<= getEnd())
			return true;
		return false;	// else
	}
	
	
	// assuming just one homolog
	public boolean addHomolog(Gene g, Exon e) {

		if (homologs== null)	// create new
			homologs= new HashMap();

		if (homologs.get(g)!= null) {
			if (homologs.get(g)!= e)
				System.err.println("Multiple exon homology: "+ e+ ", "+homologs.get(g));	
			return false;
		}
	
		homologs.put(g, e);
		return true;
	}
	
	// assuming just one homolog
	public Exon getHomolog(Gene g) {
		
		if (homologs== null)
			return null;
		return (Exon) homologs.get(g);
	}
	
	public boolean addHit(Gene g, PWHit h) {
		
		if (superExon!= null)
			superExon.addHit(g, h);	// delegate to super-exon if there is some
		
		Vector v= null;
		if (hitparade== null)	// create new
			hitparade= new HashMap();
		else 
			v= (Vector) hitparade.get(g);	// lookup existing
		
		if (v== null)
			v= new Vector();
		else 
			for (int i = 0; i < v.size(); i++) {	// check for already added hit
				PWHit hit= (PWHit) v.elementAt(i);
				if (hit.getOtherObject(this)== h.getOtherObject(this))
					return false;
			}
		
			// keep sorted with ascending costs
//		int i= 0;
//		for (i = 0; i < v.size(); i++) 
//			if (((PWHit) v.elementAt(i)).getCost()> h.getCost())
//				break;
//		v.insertElementAt(h, i);	// add
		v.add(h);
		hitparade.put(g, v);
		return true;
	}
	
	public PWHit[] getBestHits(Gene g) {
		
		if (hitparade== null|| hitparade.get(g)== null)
			return null;
		
		Vector v= (Vector) hitparade.get(g);
		Vector bestHits= new Vector();
		int bestScore= (-1);
		for (Iterator iter = v.iterator(); iter.hasNext();) {
			PWHit tmpHit = (PWHit) iter.next();
			if (tmpHit.getScore()== bestScore) 			// more hits
				bestHits.add(tmpHit);
			else if (tmpHit.getScore()> bestScore) {	// new best score
				bestHits.removeAllElements();
				bestHits.add(tmpHit);
				bestScore= tmpHit.getScore();
			}
		}
		
		PWHit[] result= new PWHit[bestHits.size()];
		for (int i = 0; i < result.length; i++) 
			result[i]= (PWHit) bestHits.elementAt(i);
		return result;
	}
	
	public boolean addTranscript(Transcript trans) {
		
			// new transcipt array
		if (transcripts== null) {
			transcripts= new Transcript[] {trans};
			return true;
		}
		
			// search transcript
		for (int i = 0; i < transcripts.length; i++) 
			if (transcripts[i].getStableID().equalsIgnoreCase(trans.getStableID()))
				return false;
		
			// add transcript
		Transcript[] nTranscripts= new Transcript[transcripts.length+ 1];
		for (int i= 0; i < transcripts.length; i++) 
			nTranscripts[i]= transcripts[i];
		nTranscripts[nTranscripts.length- 1]= trans;
		transcripts= nTranscripts;
		return true;
	}


	/**
	 * @param b
	 */
	public boolean checkStrand(boolean b) {
		
		return (b== getGene().isForward());
	}
	public boolean checkStrand(String newStrand) {
		
		String nStrand= newStrand.trim();
		if (nStrand.equals("1"))	// || nStrand.equals("forward")
			return checkStrand(true);
		else if (nStrand.equals("-1"))	// || nStrand.equals("reverse")
			return checkStrand(false);
		
		return false; // error			
	}
	
	Transcript[] transcripts= null;
	
	String exonID= null;	
	public Exon(Transcript newTranscript, String stableExonID, int start, int end) {

		this.strand= newTranscript.getStrand();
		
			// check for duplicate
		addTranscript(newTranscript);		
					
		setStart(start);
		setEnd(end);
		
			// decompose ID
		this.exonID= stableExonID;
	}	
	/**
	 * @return
	 */
	public String getExonID() {
		return exonID;
	}

	/**
	 * @return
	 */
	public Gene getGene() {
		return transcripts[0].getGene();
	}
	
	/**
	 * @return
	 */
	public Transcript[] getTranscripts() {
		return transcripts;
	}

	/**
	 * @param transcripts
	 */
	public void setTranscripts(Transcript[] transcripts) {
		this.transcripts = transcripts;
	}
	
	public String toString() {
		return getExonID();
	}

	public String toPosString() {
		return getGene().getChromosome()+" "+getStart()+" "+getEnd();
	}

	public String getChromosome() {
		return getGene().getChromosome();
	}
	
	public Species getSpecies() {
		return getGene().getSpecies();
	}

	static final long serialVersionUID = 8914674126313232057L;
	/**
	 * @return Returns the homologs.
	 */
	public HashMap getHomologs() {
		return homologs;
	}
	
	public SuperExon getSuperExon() {
		return superExon;
	}
	public void setSuperExon(SuperExon superExon) {
		this.superExon = superExon;
	}
	public SpliceSite getAcceptor() {
		return acceptor;
	}
	public void setAcceptor(SpliceSite acceptor) {
		this.acceptor = acceptor;
	}
	public SpliceSite getDonor() {
		return donor;
	}
	public void setDonor(SpliceSite donor) {
		this.donor = donor;
	}
	
	public AbstractSite getStartSite() {
		return getGene().getSite(getStart());
	}

	public AbstractSite getEndSite() {
		return getGene().getSite(getEnd());
	}
}