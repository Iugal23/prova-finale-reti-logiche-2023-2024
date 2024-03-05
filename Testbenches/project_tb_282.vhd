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

constant SCENARIO_LENGTH : integer := 458;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (196,0,167,0,14,0,0,0,0,0,8,0,69,0,132,0,0,0,240,0,162,0,89,0,135,0,161,0,99,0,194,0,185,0,140,0,53,0,159,0,0,0,105,0,104,0,167,0,190,0,68,0,128,0,157,0,199,0,162,0,0,0,0,0,0,0,72,0,0,0,159,0,159,0,167,0,90,0,0,0,0,0,219,0,0,0,80,0,0,0,201,0,220,0,226,0,164,0,250,0,72,0,167,0,85,0,17,0,0,0,0,0,212,0,0,0,0,0,174,0,172,0,246,0,0,0,111,0,0,0,28,0,149,0,237,0,98,0,136,0,0,0,131,0,118,0,165,0,161,0,160,0,117,0,189,0,243,0,205,0,128,0,34,0,239,0,213,0,237,0,82,0,2,0,72,0,206,0,87,0,29,0,158,0,201,0,182,0,113,0,17,0,39,0,108,0,210,0,144,0,0,0,249,0,221,0,127,0,181,0,21,0,0,0,159,0,142,0,94,0,139,0,8,0,205,0,0,0,108,0,153,0,252,0,0,0,220,0,201,0,252,0,118,0,48,0,0,0,71,0,26,0,1,0,0,0,0,0,194,0,0,0,204,0,84,0,94,0,60,0,165,0,123,0,133,0,39,0,13,0,14,0,0,0,158,0,80,0,247,0,0,0,156,0,138,0,19,0,48,0,0,0,133,0,5,0,52,0,229,0,190,0,164,0,184,0,0,0,252,0,0,0,99,0,95,0,0,0,0,0,161,0,201,0,230,0,56,0,0,0,0,0,0,0,0,0,69,0,250,0,78,0,130,0,151,0,170,0,228,0,127,0,15,0,41,0,253,0,250,0,0,0,196,0,163,0,0,0,3,0,78,0,0,0,0,0,48,0,225,0,204,0,224,0,141,0,159,0,0,0,211,0,138,0,112,0,119,0,179,0,149,0,0,0,0,0,81,0,0,0,130,0,0,0,101,0,169,0,207,0,198,0,23,0,98,0,194,0,204,0,219,0,227,0,218,0,6,0,250,0,155,0,54,0,165,0,32,0,0,0,70,0,173,0,142,0,221,0,0,0,5,0,107,0,0,0,148,0,129,0,50,0,150,0,249,0,243,0,32,0,115,0,0,0,249,0,5,0,0,0,15,0,99,0,0,0,0,0,121,0,37,0,24,0,86,0,131,0,130,0,71,0,218,0,61,0,233,0,250,0,195,0,222,0,0,0,224,0,176,0,0,0,5,0,225,0,104,0,124,0,177,0,64,0,27,0,96,0,215,0,0,0,91,0,0,0,0,0,0,0,0,0,0,0,244,0,216,0,241,0,178,0,0,0,8,0,0,0,202,0,251,0,89,0,220,0,162,0,0,0,137,0,0,0,65,0,57,0,247,0,22,0,105,0,60,0,141,0,0,0,115,0,0,0,161,0,126,0,22,0,0,0,183,0,229,0,0,0,0,0,19,0,209,0,72,0,57,0,41,0,189,0,0,0,0,0,171,0,0,0,11,0,13,0,22,0,83,0,212,0,151,0,181,0,163,0,107,0,226,0,1,0,182,0,203,0,99,0,165,0,117,0,55,0,203,0,73,0,47,0,103,0,242,0,117,0,195,0,107,0,123,0,0,0,94,0,95,0,0,0,37,0,212,0,129,0,252,0,188,0,238,0,0,0,76,0,245,0,95,0,218,0,0,0,0,0,214,0,0,0,50,0,178,0,191,0,0,0,0,0,68,0,182,0,254,0,144,0,230,0,174,0,231,0,198,0,0,0,34,0,253,0,50,0,46,0,125,0,19,0,121,0,108,0,23,0,194,0,56,0,4,0,0,0,142,0,248,0,0,0,175,0,141,0,0,0,231,0,6,0,58,0,63,0,0,0,0,0,159,0,170,0,20,0,48,0,208,0,225,0,175,0,190,0,125,0,0,0,0,0,53,0,225,0,229,0,0,0,208,0,95,0,0,0,157,0,220,0,0,0,210,0,21,0,160,0,0,0,83,0,0,0,91,0,0,0,152,0,0,0,0,0,242,0,0,0,0,0,66,0,0,0,110,0,104,0,80,0,127,0,39,0,38,0,0,0);
signal scenario_full  : scenario_type := (196,31,167,31,14,31,14,30,14,29,8,31,69,31,132,31,132,30,240,31,162,31,89,31,135,31,161,31,99,31,194,31,185,31,140,31,53,31,159,31,159,30,105,31,104,31,167,31,190,31,68,31,128,31,157,31,199,31,162,31,162,30,162,29,162,28,72,31,72,30,159,31,159,31,167,31,90,31,90,30,90,29,219,31,219,30,80,31,80,30,201,31,220,31,226,31,164,31,250,31,72,31,167,31,85,31,17,31,17,30,17,29,212,31,212,30,212,29,174,31,172,31,246,31,246,30,111,31,111,30,28,31,149,31,237,31,98,31,136,31,136,30,131,31,118,31,165,31,161,31,160,31,117,31,189,31,243,31,205,31,128,31,34,31,239,31,213,31,237,31,82,31,2,31,72,31,206,31,87,31,29,31,158,31,201,31,182,31,113,31,17,31,39,31,108,31,210,31,144,31,144,30,249,31,221,31,127,31,181,31,21,31,21,30,159,31,142,31,94,31,139,31,8,31,205,31,205,30,108,31,153,31,252,31,252,30,220,31,201,31,252,31,118,31,48,31,48,30,71,31,26,31,1,31,1,30,1,29,194,31,194,30,204,31,84,31,94,31,60,31,165,31,123,31,133,31,39,31,13,31,14,31,14,30,158,31,80,31,247,31,247,30,156,31,138,31,19,31,48,31,48,30,133,31,5,31,52,31,229,31,190,31,164,31,184,31,184,30,252,31,252,30,99,31,95,31,95,30,95,29,161,31,201,31,230,31,56,31,56,30,56,29,56,28,56,27,69,31,250,31,78,31,130,31,151,31,170,31,228,31,127,31,15,31,41,31,253,31,250,31,250,30,196,31,163,31,163,30,3,31,78,31,78,30,78,29,48,31,225,31,204,31,224,31,141,31,159,31,159,30,211,31,138,31,112,31,119,31,179,31,149,31,149,30,149,29,81,31,81,30,130,31,130,30,101,31,169,31,207,31,198,31,23,31,98,31,194,31,204,31,219,31,227,31,218,31,6,31,250,31,155,31,54,31,165,31,32,31,32,30,70,31,173,31,142,31,221,31,221,30,5,31,107,31,107,30,148,31,129,31,50,31,150,31,249,31,243,31,32,31,115,31,115,30,249,31,5,31,5,30,15,31,99,31,99,30,99,29,121,31,37,31,24,31,86,31,131,31,130,31,71,31,218,31,61,31,233,31,250,31,195,31,222,31,222,30,224,31,176,31,176,30,5,31,225,31,104,31,124,31,177,31,64,31,27,31,96,31,215,31,215,30,91,31,91,30,91,29,91,28,91,27,91,26,244,31,216,31,241,31,178,31,178,30,8,31,8,30,202,31,251,31,89,31,220,31,162,31,162,30,137,31,137,30,65,31,57,31,247,31,22,31,105,31,60,31,141,31,141,30,115,31,115,30,161,31,126,31,22,31,22,30,183,31,229,31,229,30,229,29,19,31,209,31,72,31,57,31,41,31,189,31,189,30,189,29,171,31,171,30,11,31,13,31,22,31,83,31,212,31,151,31,181,31,163,31,107,31,226,31,1,31,182,31,203,31,99,31,165,31,117,31,55,31,203,31,73,31,47,31,103,31,242,31,117,31,195,31,107,31,123,31,123,30,94,31,95,31,95,30,37,31,212,31,129,31,252,31,188,31,238,31,238,30,76,31,245,31,95,31,218,31,218,30,218,29,214,31,214,30,50,31,178,31,191,31,191,30,191,29,68,31,182,31,254,31,144,31,230,31,174,31,231,31,198,31,198,30,34,31,253,31,50,31,46,31,125,31,19,31,121,31,108,31,23,31,194,31,56,31,4,31,4,30,142,31,248,31,248,30,175,31,141,31,141,30,231,31,6,31,58,31,63,31,63,30,63,29,159,31,170,31,20,31,48,31,208,31,225,31,175,31,190,31,125,31,125,30,125,29,53,31,225,31,229,31,229,30,208,31,95,31,95,30,157,31,220,31,220,30,210,31,21,31,160,31,160,30,83,31,83,30,91,31,91,30,152,31,152,30,152,29,242,31,242,30,242,29,66,31,66,30,110,31,104,31,80,31,127,31,39,31,38,31,38,30);

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
