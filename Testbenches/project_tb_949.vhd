-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_949 is
end project_tb_949;

architecture project_tb_arch_949 of project_tb_949 is
    constant CLOCK_PERIOD : time := 20 ns;
    signal tb_clk : std_logic := '0';
    signal tb_rst, tb_start, tb_done : std_logic;
    signal tb_add : std_logic_vector(15 downto 0);
    signal tb_k   : std_logic_vector(9 downto 0);

    signal tb_o_mem_addr, exc_o_mem_addr, init_o_mem_addr : std_logic_vector(15 downto 0);
    signal tb_o_mem_data, exc_o_mem_data, init_o_mem_data : std_logic_vector(7 downto 0);
    signal tb_i_mem_data : std_logic_vector(7 downto 0);
    signal tb_o_mem_we, tb_o_mem_en, exc_o_mem_we, exc_o_mem_en, init_o_mem_we, init_o_mem_en : std_logic;

    type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);
    signal RAM : ram_type := (OTHERS => "00000000");

constant SCENARIO_LENGTH : integer := 362;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (68,0,0,0,0,0,18,0,98,0,97,0,0,0,179,0,245,0,17,0,221,0,249,0,0,0,234,0,227,0,59,0,0,0,46,0,34,0,200,0,216,0,0,0,218,0,23,0,0,0,33,0,173,0,142,0,231,0,249,0,12,0,0,0,124,0,28,0,172,0,123,0,38,0,79,0,180,0,23,0,142,0,94,0,0,0,0,0,230,0,209,0,248,0,70,0,51,0,0,0,58,0,32,0,127,0,130,0,224,0,223,0,42,0,120,0,20,0,0,0,210,0,0,0,83,0,168,0,0,0,71,0,251,0,92,0,220,0,248,0,34,0,79,0,93,0,117,0,248,0,169,0,0,0,51,0,218,0,209,0,0,0,156,0,0,0,72,0,19,0,61,0,197,0,237,0,40,0,0,0,73,0,148,0,0,0,135,0,6,0,146,0,146,0,10,0,57,0,0,0,32,0,185,0,225,0,255,0,34,0,46,0,0,0,98,0,166,0,146,0,158,0,110,0,0,0,208,0,0,0,176,0,74,0,95,0,176,0,135,0,69,0,126,0,82,0,255,0,124,0,202,0,234,0,62,0,69,0,95,0,59,0,0,0,131,0,193,0,110,0,216,0,24,0,101,0,18,0,15,0,56,0,34,0,0,0,0,0,42,0,195,0,10,0,182,0,0,0,217,0,220,0,40,0,136,0,235,0,0,0,0,0,71,0,40,0,223,0,0,0,0,0,196,0,4,0,206,0,43,0,0,0,95,0,0,0,174,0,32,0,59,0,47,0,225,0,97,0,19,0,66,0,184,0,216,0,24,0,109,0,135,0,195,0,173,0,18,0,238,0,136,0,237,0,0,0,205,0,188,0,0,0,12,0,9,0,65,0,128,0,10,0,0,0,239,0,0,0,129,0,238,0,19,0,0,0,183,0,38,0,109,0,182,0,0,0,200,0,41,0,0,0,139,0,95,0,138,0,0,0,23,0,217,0,1,0,0,0,4,0,0,0,157,0,241,0,10,0,167,0,0,0,0,0,242,0,89,0,41,0,80,0,0,0,0,0,0,0,160,0,171,0,248,0,74,0,235,0,89,0,85,0,64,0,0,0,83,0,153,0,53,0,0,0,134,0,238,0,230,0,220,0,0,0,0,0,30,0,7,0,218,0,199,0,0,0,138,0,55,0,96,0,212,0,136,0,88,0,0,0,48,0,216,0,196,0,76,0,15,0,71,0,15,0,251,0,195,0,232,0,158,0,214,0,252,0,168,0,136,0,179,0,183,0,205,0,147,0,0,0,82,0,66,0,112,0,77,0,113,0,16,0,133,0,0,0,45,0,31,0,0,0,0,0,176,0,53,0,0,0,0,0,20,0,226,0,20,0,0,0,171,0,0,0,80,0,237,0,134,0,215,0,0,0,148,0,79,0,183,0,100,0,165,0,142,0,39,0,1,0,0,0,0,0,146,0,134,0,141,0,0,0,251,0,0,0,122,0,212,0,244,0,118,0,22,0,0,0,38,0,0,0,101,0,216,0,197,0,14,0,50,0,223,0,48,0,199,0,120,0,245,0,76,0,205,0,116,0,0,0,91,0,223,0,0,0,0,0,41,0,107,0,0,0,124,0,0,0,51,0,184,0,148,0);
signal scenario_full  : scenario_type := (68,31,68,30,68,29,18,31,98,31,97,31,97,30,179,31,245,31,17,31,221,31,249,31,249,30,234,31,227,31,59,31,59,30,46,31,34,31,200,31,216,31,216,30,218,31,23,31,23,30,33,31,173,31,142,31,231,31,249,31,12,31,12,30,124,31,28,31,172,31,123,31,38,31,79,31,180,31,23,31,142,31,94,31,94,30,94,29,230,31,209,31,248,31,70,31,51,31,51,30,58,31,32,31,127,31,130,31,224,31,223,31,42,31,120,31,20,31,20,30,210,31,210,30,83,31,168,31,168,30,71,31,251,31,92,31,220,31,248,31,34,31,79,31,93,31,117,31,248,31,169,31,169,30,51,31,218,31,209,31,209,30,156,31,156,30,72,31,19,31,61,31,197,31,237,31,40,31,40,30,73,31,148,31,148,30,135,31,6,31,146,31,146,31,10,31,57,31,57,30,32,31,185,31,225,31,255,31,34,31,46,31,46,30,98,31,166,31,146,31,158,31,110,31,110,30,208,31,208,30,176,31,74,31,95,31,176,31,135,31,69,31,126,31,82,31,255,31,124,31,202,31,234,31,62,31,69,31,95,31,59,31,59,30,131,31,193,31,110,31,216,31,24,31,101,31,18,31,15,31,56,31,34,31,34,30,34,29,42,31,195,31,10,31,182,31,182,30,217,31,220,31,40,31,136,31,235,31,235,30,235,29,71,31,40,31,223,31,223,30,223,29,196,31,4,31,206,31,43,31,43,30,95,31,95,30,174,31,32,31,59,31,47,31,225,31,97,31,19,31,66,31,184,31,216,31,24,31,109,31,135,31,195,31,173,31,18,31,238,31,136,31,237,31,237,30,205,31,188,31,188,30,12,31,9,31,65,31,128,31,10,31,10,30,239,31,239,30,129,31,238,31,19,31,19,30,183,31,38,31,109,31,182,31,182,30,200,31,41,31,41,30,139,31,95,31,138,31,138,30,23,31,217,31,1,31,1,30,4,31,4,30,157,31,241,31,10,31,167,31,167,30,167,29,242,31,89,31,41,31,80,31,80,30,80,29,80,28,160,31,171,31,248,31,74,31,235,31,89,31,85,31,64,31,64,30,83,31,153,31,53,31,53,30,134,31,238,31,230,31,220,31,220,30,220,29,30,31,7,31,218,31,199,31,199,30,138,31,55,31,96,31,212,31,136,31,88,31,88,30,48,31,216,31,196,31,76,31,15,31,71,31,15,31,251,31,195,31,232,31,158,31,214,31,252,31,168,31,136,31,179,31,183,31,205,31,147,31,147,30,82,31,66,31,112,31,77,31,113,31,16,31,133,31,133,30,45,31,31,31,31,30,31,29,176,31,53,31,53,30,53,29,20,31,226,31,20,31,20,30,171,31,171,30,80,31,237,31,134,31,215,31,215,30,148,31,79,31,183,31,100,31,165,31,142,31,39,31,1,31,1,30,1,29,146,31,134,31,141,31,141,30,251,31,251,30,122,31,212,31,244,31,118,31,22,31,22,30,38,31,38,30,101,31,216,31,197,31,14,31,50,31,223,31,48,31,199,31,120,31,245,31,76,31,205,31,116,31,116,30,91,31,223,31,223,30,223,29,41,31,107,31,107,30,124,31,124,30,51,31,184,31,148,31);

    signal memory_control : std_logic := '0';
    
    constant SCENARIO_ADDRESS : integer := 1234;

    component project_reti_logiche is
        port (
                i_clk : in std_logic;
                i_rst : in std_logic;
                i_start : in std_logic;
                i_add : in std_logic_vector(15 downto 0);
                i_k   : in std_logic_vector(9 downto 0);
                
                o_done : out std_logic;
                
                o_mem_addr : out std_logic_vector(15 downto 0);
                i_mem_data : in  std_logic_vector(7 downto 0);
                o_mem_data : out std_logic_vector(7 downto 0);
                o_mem_we   : out std_logic;
                o_mem_en   : out std_logic
        );
    end component project_reti_logiche;

begin
    UUT : project_reti_logiche
    port map(
                i_clk   => tb_clk,
                i_rst   => tb_rst,
                i_start => tb_start,
                i_add   => tb_add,
                i_k     => tb_k,
                
                o_done => tb_done,
                
                o_mem_addr => exc_o_mem_addr,
                i_mem_data => tb_i_mem_data,
                o_mem_data => exc_o_mem_data,
                o_mem_we   => exc_o_mem_we,
                o_mem_en   => exc_o_mem_en
    );

    -- Clock generation
    tb_clk <= not tb_clk after CLOCK_PERIOD/2;

    -- Process related to the memory
    MEM : process (tb_clk)
    begin
        if tb_clk'event and tb_clk = '1' then
            if tb_o_mem_en = '1' then
                if tb_o_mem_we = '1' then
                    RAM(to_integer(unsigned(tb_o_mem_addr))) <= tb_o_mem_data after 1 ns;
                    tb_i_mem_data <= tb_o_mem_data after 1 ns;
                else
                    tb_i_mem_data <= RAM(to_integer(unsigned(tb_o_mem_addr))) after 1 ns;
                end if;
            end if;
        end if;
    end process;
    
    memory_signal_swapper : process(memory_control, init_o_mem_addr, init_o_mem_data,
                                    init_o_mem_en,  init_o_mem_we,   exc_o_mem_addr,
                                    exc_o_mem_data, exc_o_mem_en, exc_o_mem_we)
    begin
        -- This is necessary for the testbench to work: we swap the memory
        -- signals from the component to the testbench when needed.
    
        tb_o_mem_addr <= init_o_mem_addr;
        tb_o_mem_data <= init_o_mem_data;
        tb_o_mem_en   <= init_o_mem_en;
        tb_o_mem_we   <= init_o_mem_we;

        if memory_control = '1' then
            tb_o_mem_addr <= exc_o_mem_addr;
            tb_o_mem_data <= exc_o_mem_data;
            tb_o_mem_en   <= exc_o_mem_en;
            tb_o_mem_we   <= exc_o_mem_we;
        end if;
    end process;
    
    -- This process provides the correct scenario on the signal controlled by the TB
    create_scenario : process
    begin
        wait for 50 ns;

        -- Signal initialization and reset of the component
        tb_start <= '0';
        tb_add <= (others=>'0');
        tb_k   <= (others=>'0');
        tb_rst <= '1';
        
        -- Wait some time for the component to reset...
        wait for 50 ns;
        
        tb_rst <= '0';
        memory_control <= '0';  -- Memory controlled by the testbench
        
        wait until falling_edge(tb_clk); -- Skew the testbench transitions with respect to the clock

        -- Configure the memory        
        for i in 0 to SCENARIO_LENGTH*2-1 loop
            init_o_mem_addr<= std_logic_vector(to_unsigned(SCENARIO_ADDRESS+i, 16));
            init_o_mem_data<= std_logic_vector(to_unsigned(scenario_input(i),8));
            init_o_mem_en  <= '1';
            init_o_mem_we  <= '1';
            wait until rising_edge(tb_clk);   
        end loop;
        
        wait until falling_edge(tb_clk);

        memory_control <= '1';  -- Memory controlled by the component
        
        tb_add <= std_logic_vector(to_unsigned(SCENARIO_ADDRESS, 16));
        tb_k   <= std_logic_vector(to_unsigned(SCENARIO_LENGTH, 10));
        
        tb_start <= '1';

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        wait for 5 ns;
        
        tb_start <= '0';
        
        wait;
        
    end process;

    -- Process without sensitivity list designed to test the actual component.
    test_routine : process
    begin

        wait until tb_rst = '1';
        wait for 25 ns;
        assert tb_done = '0' report "TEST FALLITO o_done !=0 during reset" severity failure;
        wait until tb_rst = '0';

        wait until falling_edge(tb_clk);
        assert tb_done = '0' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        
        wait until rising_edge(tb_start);

        while tb_done /= '1' loop                
            wait until rising_edge(tb_clk);
        end loop;

        assert tb_o_mem_en = '0' or tb_o_mem_we = '0' report "TEST FALLITO o_mem_en !=0 memory should not be written after done." severity failure;

        for i in 0 to SCENARIO_LENGTH*2-1 loop
            assert RAM(SCENARIO_ADDRESS+i) = std_logic_vector(to_unsigned(scenario_full(i),8)) report "TEST FALLITO @ OFFSET=" & integer'image(i) & " expected= " & integer'image(scenario_full(i)) & " actual=" & integer'image(to_integer(unsigned(RAM(i)))) severity failure;
        end loop;

        wait until falling_edge(tb_start);
        assert tb_done = '1' report "TEST FALLITO o_done !=0 after reset before start" severity failure;
        wait until falling_edge(tb_done);

        assert false report "Simulation Ended! TEST PASSATO (EXAMPLE)" severity failure;
    end process;

end architecture;
