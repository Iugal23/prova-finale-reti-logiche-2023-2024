-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_849 is
end project_tb_849;

architecture project_tb_arch_849 of project_tb_849 is
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

constant SCENARIO_LENGTH : integer := 407;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (196,0,3,0,126,0,129,0,0,0,125,0,103,0,195,0,0,0,246,0,69,0,249,0,249,0,32,0,0,0,231,0,191,0,169,0,0,0,190,0,229,0,9,0,17,0,0,0,129,0,0,0,63,0,0,0,130,0,196,0,0,0,0,0,71,0,0,0,15,0,190,0,238,0,26,0,0,0,219,0,124,0,138,0,128,0,229,0,191,0,0,0,132,0,0,0,108,0,157,0,229,0,222,0,185,0,0,0,62,0,0,0,6,0,137,0,0,0,192,0,219,0,231,0,0,0,160,0,0,0,201,0,103,0,247,0,0,0,0,0,137,0,89,0,166,0,241,0,226,0,217,0,132,0,174,0,115,0,0,0,113,0,120,0,182,0,197,0,0,0,0,0,205,0,0,0,159,0,130,0,27,0,99,0,0,0,137,0,116,0,191,0,17,0,0,0,125,0,199,0,0,0,208,0,250,0,0,0,0,0,0,0,176,0,68,0,179,0,220,0,0,0,128,0,146,0,14,0,0,0,199,0,96,0,33,0,132,0,225,0,16,0,123,0,158,0,151,0,0,0,0,0,69,0,45,0,0,0,6,0,228,0,0,0,58,0,140,0,181,0,118,0,102,0,238,0,186,0,76,0,0,0,75,0,48,0,79,0,230,0,0,0,0,0,121,0,0,0,149,0,0,0,57,0,224,0,0,0,187,0,4,0,206,0,77,0,0,0,0,0,0,0,232,0,174,0,0,0,0,0,0,0,14,0,41,0,170,0,0,0,239,0,236,0,3,0,158,0,240,0,26,0,46,0,205,0,0,0,115,0,116,0,62,0,0,0,0,0,24,0,227,0,235,0,57,0,188,0,17,0,181,0,185,0,155,0,223,0,188,0,87,0,188,0,0,0,152,0,194,0,0,0,254,0,239,0,209,0,90,0,223,0,167,0,226,0,0,0,75,0,6,0,0,0,13,0,217,0,181,0,53,0,124,0,236,0,57,0,179,0,0,0,0,0,110,0,164,0,85,0,0,0,191,0,0,0,130,0,122,0,46,0,129,0,0,0,192,0,238,0,209,0,170,0,45,0,107,0,18,0,233,0,101,0,95,0,131,0,20,0,170,0,118,0,146,0,98,0,42,0,0,0,101,0,68,0,0,0,0,0,90,0,15,0,124,0,251,0,67,0,36,0,0,0,54,0,1,0,177,0,0,0,183,0,42,0,197,0,0,0,184,0,0,0,136,0,138,0,73,0,0,0,0,0,103,0,253,0,251,0,191,0,148,0,172,0,211,0,182,0,244,0,4,0,134,0,86,0,89,0,0,0,160,0,65,0,47,0,233,0,0,0,117,0,0,0,194,0,249,0,0,0,155,0,50,0,141,0,41,0,157,0,0,0,215,0,47,0,23,0,7,0,0,0,0,0,70,0,148,0,161,0,227,0,0,0,0,0,173,0,138,0,206,0,125,0,0,0,0,0,213,0,0,0,30,0,0,0,214,0,130,0,233,0,0,0,0,0,0,0,0,0,70,0,0,0,173,0,233,0,54,0,151,0,0,0,184,0,114,0,62,0,0,0,45,0,0,0,31,0,0,0,245,0,241,0,232,0,241,0,217,0,150,0,179,0,168,0,0,0,89,0,60,0,172,0,0,0,85,0,0,0,239,0,5,0,0,0,3,0,170,0,174,0,142,0,235,0,59,0,26,0,203,0,100,0,112,0,202,0,49,0,0,0,0,0,160,0,22,0,67,0,97,0,31,0,204,0,24,0,41,0,20,0,204,0,97,0,0,0,0,0,228,0,252,0,244,0,74,0,0,0,116,0,74,0,0,0,132,0,20,0,112,0);
signal scenario_full  : scenario_type := (196,31,3,31,126,31,129,31,129,30,125,31,103,31,195,31,195,30,246,31,69,31,249,31,249,31,32,31,32,30,231,31,191,31,169,31,169,30,190,31,229,31,9,31,17,31,17,30,129,31,129,30,63,31,63,30,130,31,196,31,196,30,196,29,71,31,71,30,15,31,190,31,238,31,26,31,26,30,219,31,124,31,138,31,128,31,229,31,191,31,191,30,132,31,132,30,108,31,157,31,229,31,222,31,185,31,185,30,62,31,62,30,6,31,137,31,137,30,192,31,219,31,231,31,231,30,160,31,160,30,201,31,103,31,247,31,247,30,247,29,137,31,89,31,166,31,241,31,226,31,217,31,132,31,174,31,115,31,115,30,113,31,120,31,182,31,197,31,197,30,197,29,205,31,205,30,159,31,130,31,27,31,99,31,99,30,137,31,116,31,191,31,17,31,17,30,125,31,199,31,199,30,208,31,250,31,250,30,250,29,250,28,176,31,68,31,179,31,220,31,220,30,128,31,146,31,14,31,14,30,199,31,96,31,33,31,132,31,225,31,16,31,123,31,158,31,151,31,151,30,151,29,69,31,45,31,45,30,6,31,228,31,228,30,58,31,140,31,181,31,118,31,102,31,238,31,186,31,76,31,76,30,75,31,48,31,79,31,230,31,230,30,230,29,121,31,121,30,149,31,149,30,57,31,224,31,224,30,187,31,4,31,206,31,77,31,77,30,77,29,77,28,232,31,174,31,174,30,174,29,174,28,14,31,41,31,170,31,170,30,239,31,236,31,3,31,158,31,240,31,26,31,46,31,205,31,205,30,115,31,116,31,62,31,62,30,62,29,24,31,227,31,235,31,57,31,188,31,17,31,181,31,185,31,155,31,223,31,188,31,87,31,188,31,188,30,152,31,194,31,194,30,254,31,239,31,209,31,90,31,223,31,167,31,226,31,226,30,75,31,6,31,6,30,13,31,217,31,181,31,53,31,124,31,236,31,57,31,179,31,179,30,179,29,110,31,164,31,85,31,85,30,191,31,191,30,130,31,122,31,46,31,129,31,129,30,192,31,238,31,209,31,170,31,45,31,107,31,18,31,233,31,101,31,95,31,131,31,20,31,170,31,118,31,146,31,98,31,42,31,42,30,101,31,68,31,68,30,68,29,90,31,15,31,124,31,251,31,67,31,36,31,36,30,54,31,1,31,177,31,177,30,183,31,42,31,197,31,197,30,184,31,184,30,136,31,138,31,73,31,73,30,73,29,103,31,253,31,251,31,191,31,148,31,172,31,211,31,182,31,244,31,4,31,134,31,86,31,89,31,89,30,160,31,65,31,47,31,233,31,233,30,117,31,117,30,194,31,249,31,249,30,155,31,50,31,141,31,41,31,157,31,157,30,215,31,47,31,23,31,7,31,7,30,7,29,70,31,148,31,161,31,227,31,227,30,227,29,173,31,138,31,206,31,125,31,125,30,125,29,213,31,213,30,30,31,30,30,214,31,130,31,233,31,233,30,233,29,233,28,233,27,70,31,70,30,173,31,233,31,54,31,151,31,151,30,184,31,114,31,62,31,62,30,45,31,45,30,31,31,31,30,245,31,241,31,232,31,241,31,217,31,150,31,179,31,168,31,168,30,89,31,60,31,172,31,172,30,85,31,85,30,239,31,5,31,5,30,3,31,170,31,174,31,142,31,235,31,59,31,26,31,203,31,100,31,112,31,202,31,49,31,49,30,49,29,160,31,22,31,67,31,97,31,31,31,204,31,24,31,41,31,20,31,204,31,97,31,97,30,97,29,228,31,252,31,244,31,74,31,74,30,116,31,74,31,74,30,132,31,20,31,112,31);

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
