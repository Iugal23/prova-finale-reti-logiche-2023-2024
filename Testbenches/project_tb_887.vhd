-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb is
end project_tb;

architecture project_tb_arch of project_tb is
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

constant SCENARIO_LENGTH : integer := 552;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (132,0,32,0,66,0,249,0,52,0,134,0,63,0,0,0,56,0,1,0,69,0,62,0,147,0,213,0,149,0,0,0,132,0,0,0,24,0,0,0,154,0,163,0,0,0,197,0,172,0,188,0,209,0,0,0,0,0,0,0,0,0,16,0,138,0,202,0,0,0,0,0,54,0,6,0,147,0,223,0,7,0,0,0,0,0,71,0,20,0,214,0,133,0,101,0,232,0,55,0,0,0,87,0,226,0,118,0,93,0,0,0,0,0,226,0,92,0,181,0,127,0,0,0,97,0,107,0,0,0,0,0,47,0,0,0,171,0,27,0,0,0,129,0,22,0,0,0,0,0,0,0,0,0,218,0,135,0,10,0,223,0,109,0,234,0,0,0,90,0,184,0,0,0,147,0,0,0,0,0,62,0,134,0,31,0,17,0,135,0,56,0,146,0,190,0,75,0,15,0,178,0,169,0,84,0,101,0,81,0,24,0,115,0,154,0,244,0,31,0,166,0,44,0,133,0,0,0,199,0,47,0,17,0,0,0,0,0,48,0,166,0,33,0,158,0,73,0,141,0,134,0,203,0,194,0,0,0,93,0,83,0,0,0,0,0,33,0,195,0,213,0,211,0,81,0,0,0,130,0,200,0,0,0,188,0,123,0,0,0,69,0,0,0,175,0,242,0,86,0,123,0,98,0,0,0,253,0,70,0,0,0,178,0,179,0,219,0,20,0,128,0,28,0,62,0,68,0,121,0,123,0,0,0,98,0,172,0,80,0,205,0,31,0,158,0,0,0,32,0,230,0,175,0,43,0,168,0,86,0,0,0,98,0,154,0,235,0,27,0,10,0,239,0,176,0,251,0,90,0,58,0,53,0,247,0,187,0,61,0,193,0,98,0,156,0,143,0,0,0,190,0,59,0,20,0,230,0,43,0,214,0,163,0,0,0,0,0,73,0,144,0,238,0,196,0,111,0,48,0,188,0,0,0,71,0,125,0,57,0,224,0,38,0,0,0,240,0,11,0,120,0,216,0,124,0,248,0,246,0,0,0,84,0,170,0,3,0,64,0,0,0,10,0,222,0,70,0,40,0,1,0,184,0,71,0,186,0,0,0,0,0,201,0,0,0,0,0,228,0,56,0,0,0,44,0,0,0,155,0,0,0,250,0,0,0,0,0,71,0,111,0,97,0,185,0,39,0,88,0,163,0,0,0,39,0,93,0,202,0,202,0,0,0,0,0,160,0,0,0,208,0,50,0,133,0,108,0,87,0,0,0,206,0,165,0,174,0,21,0,37,0,113,0,212,0,17,0,208,0,38,0,0,0,51,0,0,0,0,0,172,0,136,0,163,0,16,0,0,0,128,0,0,0,59,0,152,0,0,0,81,0,79,0,0,0,152,0,115,0,253,0,127,0,70,0,245,0,163,0,248,0,158,0,201,0,150,0,0,0,51,0,231,0,0,0,13,0,109,0,0,0,232,0,86,0,0,0,93,0,0,0,249,0,250,0,155,0,0,0,49,0,44,0,235,0,207,0,21,0,0,0,37,0,227,0,165,0,195,0,128,0,25,0,106,0,26,0,225,0,0,0,27,0,0,0,139,0,124,0,78,0,117,0,170,0,253,0,48,0,32,0,0,0,60,0,54,0,6,0,57,0,156,0,0,0,147,0,51,0,83,0,159,0,167,0,217,0,0,0,191,0,205,0,225,0,148,0,118,0,45,0,0,0,69,0,213,0,0,0,154,0,138,0,220,0,122,0,93,0,0,0,51,0,79,0,138,0,194,0,0,0,249,0,165,0,48,0,102,0,233,0,52,0,131,0,35,0,0,0,239,0,90,0,170,0,31,0,0,0,0,0,240,0,209,0,224,0,203,0,46,0,61,0,161,0,99,0,72,0,219,0,50,0,193,0,131,0,36,0,0,0,173,0,210,0,0,0,98,0,219,0,124,0,0,0,11,0,125,0,74,0,183,0,112,0,221,0,92,0,125,0,162,0,132,0,79,0,235,0,205,0,140,0,2,0,191,0,214,0,0,0,0,0,23,0,0,0,22,0,140,0,0,0,70,0,147,0,0,0,0,0,117,0,0,0,250,0,0,0,251,0,0,0,0,0,0,0,4,0,0,0,0,0,123,0,0,0,17,0,241,0,12,0,218,0,114,0,0,0,0,0,224,0,144,0,133,0,244,0,13,0,0,0,112,0,0,0,233,0,127,0,102,0,28,0,206,0,207,0,92,0,230,0,0,0,0,0,0,0,106,0,36,0,180,0,0,0,245,0,131,0,167,0,0,0,53,0,79,0,0,0,27,0,78,0,58,0,219,0,17,0,147,0,0,0,0,0,65,0,0,0,156,0,240,0,11,0,0,0,0,0,175,0,250,0,0,0,0,0,0,0,96,0,235,0,142,0,42,0,92,0,168,0,42,0,178,0,35,0,0,0,11,0,96,0,25,0,46,0,74,0,216,0,168,0,0,0,158,0,12,0,201,0);
signal scenario_full  : scenario_type := (132,31,32,31,66,31,249,31,52,31,134,31,63,31,63,30,56,31,1,31,69,31,62,31,147,31,213,31,149,31,149,30,132,31,132,30,24,31,24,30,154,31,163,31,163,30,197,31,172,31,188,31,209,31,209,30,209,29,209,28,209,27,16,31,138,31,202,31,202,30,202,29,54,31,6,31,147,31,223,31,7,31,7,30,7,29,71,31,20,31,214,31,133,31,101,31,232,31,55,31,55,30,87,31,226,31,118,31,93,31,93,30,93,29,226,31,92,31,181,31,127,31,127,30,97,31,107,31,107,30,107,29,47,31,47,30,171,31,27,31,27,30,129,31,22,31,22,30,22,29,22,28,22,27,218,31,135,31,10,31,223,31,109,31,234,31,234,30,90,31,184,31,184,30,147,31,147,30,147,29,62,31,134,31,31,31,17,31,135,31,56,31,146,31,190,31,75,31,15,31,178,31,169,31,84,31,101,31,81,31,24,31,115,31,154,31,244,31,31,31,166,31,44,31,133,31,133,30,199,31,47,31,17,31,17,30,17,29,48,31,166,31,33,31,158,31,73,31,141,31,134,31,203,31,194,31,194,30,93,31,83,31,83,30,83,29,33,31,195,31,213,31,211,31,81,31,81,30,130,31,200,31,200,30,188,31,123,31,123,30,69,31,69,30,175,31,242,31,86,31,123,31,98,31,98,30,253,31,70,31,70,30,178,31,179,31,219,31,20,31,128,31,28,31,62,31,68,31,121,31,123,31,123,30,98,31,172,31,80,31,205,31,31,31,158,31,158,30,32,31,230,31,175,31,43,31,168,31,86,31,86,30,98,31,154,31,235,31,27,31,10,31,239,31,176,31,251,31,90,31,58,31,53,31,247,31,187,31,61,31,193,31,98,31,156,31,143,31,143,30,190,31,59,31,20,31,230,31,43,31,214,31,163,31,163,30,163,29,73,31,144,31,238,31,196,31,111,31,48,31,188,31,188,30,71,31,125,31,57,31,224,31,38,31,38,30,240,31,11,31,120,31,216,31,124,31,248,31,246,31,246,30,84,31,170,31,3,31,64,31,64,30,10,31,222,31,70,31,40,31,1,31,184,31,71,31,186,31,186,30,186,29,201,31,201,30,201,29,228,31,56,31,56,30,44,31,44,30,155,31,155,30,250,31,250,30,250,29,71,31,111,31,97,31,185,31,39,31,88,31,163,31,163,30,39,31,93,31,202,31,202,31,202,30,202,29,160,31,160,30,208,31,50,31,133,31,108,31,87,31,87,30,206,31,165,31,174,31,21,31,37,31,113,31,212,31,17,31,208,31,38,31,38,30,51,31,51,30,51,29,172,31,136,31,163,31,16,31,16,30,128,31,128,30,59,31,152,31,152,30,81,31,79,31,79,30,152,31,115,31,253,31,127,31,70,31,245,31,163,31,248,31,158,31,201,31,150,31,150,30,51,31,231,31,231,30,13,31,109,31,109,30,232,31,86,31,86,30,93,31,93,30,249,31,250,31,155,31,155,30,49,31,44,31,235,31,207,31,21,31,21,30,37,31,227,31,165,31,195,31,128,31,25,31,106,31,26,31,225,31,225,30,27,31,27,30,139,31,124,31,78,31,117,31,170,31,253,31,48,31,32,31,32,30,60,31,54,31,6,31,57,31,156,31,156,30,147,31,51,31,83,31,159,31,167,31,217,31,217,30,191,31,205,31,225,31,148,31,118,31,45,31,45,30,69,31,213,31,213,30,154,31,138,31,220,31,122,31,93,31,93,30,51,31,79,31,138,31,194,31,194,30,249,31,165,31,48,31,102,31,233,31,52,31,131,31,35,31,35,30,239,31,90,31,170,31,31,31,31,30,31,29,240,31,209,31,224,31,203,31,46,31,61,31,161,31,99,31,72,31,219,31,50,31,193,31,131,31,36,31,36,30,173,31,210,31,210,30,98,31,219,31,124,31,124,30,11,31,125,31,74,31,183,31,112,31,221,31,92,31,125,31,162,31,132,31,79,31,235,31,205,31,140,31,2,31,191,31,214,31,214,30,214,29,23,31,23,30,22,31,140,31,140,30,70,31,147,31,147,30,147,29,117,31,117,30,250,31,250,30,251,31,251,30,251,29,251,28,4,31,4,30,4,29,123,31,123,30,17,31,241,31,12,31,218,31,114,31,114,30,114,29,224,31,144,31,133,31,244,31,13,31,13,30,112,31,112,30,233,31,127,31,102,31,28,31,206,31,207,31,92,31,230,31,230,30,230,29,230,28,106,31,36,31,180,31,180,30,245,31,131,31,167,31,167,30,53,31,79,31,79,30,27,31,78,31,58,31,219,31,17,31,147,31,147,30,147,29,65,31,65,30,156,31,240,31,11,31,11,30,11,29,175,31,250,31,250,30,250,29,250,28,96,31,235,31,142,31,42,31,92,31,168,31,42,31,178,31,35,31,35,30,11,31,96,31,25,31,46,31,74,31,216,31,168,31,168,30,158,31,12,31,201,31);

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
