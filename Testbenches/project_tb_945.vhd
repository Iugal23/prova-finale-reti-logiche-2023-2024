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

constant SCENARIO_LENGTH : integer := 559;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (0,0,70,0,0,0,210,0,0,0,225,0,13,0,37,0,36,0,129,0,152,0,24,0,84,0,232,0,134,0,149,0,0,0,60,0,85,0,230,0,131,0,193,0,113,0,56,0,131,0,178,0,2,0,152,0,253,0,24,0,0,0,169,0,115,0,17,0,241,0,195,0,114,0,37,0,217,0,221,0,0,0,9,0,49,0,229,0,238,0,123,0,0,0,237,0,230,0,95,0,93,0,0,0,92,0,0,0,207,0,241,0,127,0,0,0,0,0,194,0,0,0,240,0,107,0,212,0,131,0,101,0,220,0,170,0,234,0,130,0,0,0,199,0,233,0,30,0,141,0,87,0,72,0,12,0,0,0,132,0,219,0,182,0,27,0,4,0,0,0,35,0,197,0,231,0,42,0,197,0,175,0,90,0,96,0,0,0,235,0,217,0,0,0,250,0,111,0,122,0,0,0,152,0,230,0,206,0,235,0,0,0,176,0,0,0,164,0,0,0,0,0,22,0,41,0,0,0,109,0,0,0,121,0,225,0,231,0,226,0,0,0,128,0,0,0,119,0,213,0,165,0,0,0,136,0,23,0,47,0,0,0,70,0,80,0,245,0,0,0,159,0,133,0,244,0,22,0,0,0,61,0,173,0,216,0,180,0,56,0,106,0,84,0,0,0,116,0,197,0,65,0,17,0,0,0,173,0,206,0,96,0,30,0,0,0,120,0,0,0,28,0,171,0,184,0,230,0,0,0,172,0,0,0,237,0,0,0,244,0,211,0,239,0,100,0,35,0,197,0,231,0,248,0,221,0,115,0,171,0,147,0,170,0,71,0,192,0,92,0,174,0,178,0,186,0,125,0,238,0,34,0,21,0,230,0,50,0,116,0,89,0,80,0,0,0,128,0,0,0,112,0,203,0,27,0,0,0,85,0,0,0,185,0,28,0,52,0,0,0,89,0,252,0,83,0,62,0,162,0,0,0,0,0,150,0,40,0,219,0,206,0,83,0,145,0,204,0,234,0,0,0,104,0,108,0,92,0,32,0,81,0,45,0,23,0,182,0,47,0,0,0,209,0,200,0,186,0,189,0,31,0,119,0,240,0,0,0,125,0,171,0,15,0,65,0,0,0,220,0,255,0,57,0,0,0,174,0,248,0,175,0,138,0,14,0,163,0,0,0,118,0,153,0,73,0,117,0,112,0,101,0,227,0,186,0,0,0,30,0,88,0,232,0,61,0,222,0,219,0,35,0,199,0,191,0,0,0,0,0,104,0,17,0,124,0,40,0,74,0,74,0,249,0,140,0,22,0,61,0,67,0,254,0,14,0,0,0,0,0,115,0,163,0,188,0,0,0,0,0,207,0,75,0,11,0,156,0,196,0,174,0,60,0,46,0,199,0,144,0,12,0,3,0,13,0,197,0,108,0,66,0,63,0,229,0,217,0,19,0,67,0,176,0,163,0,113,0,0,0,235,0,61,0,78,0,0,0,7,0,0,0,205,0,129,0,105,0,40,0,131,0,88,0,103,0,203,0,215,0,214,0,26,0,99,0,0,0,50,0,48,0,154,0,0,0,0,0,0,0,0,0,0,0,0,0,203,0,172,0,248,0,28,0,0,0,168,0,160,0,159,0,40,0,66,0,17,0,74,0,0,0,0,0,252,0,0,0,101,0,80,0,26,0,143,0,0,0,0,0,4,0,16,0,205,0,151,0,30,0,249,0,0,0,198,0,238,0,163,0,31,0,32,0,35,0,40,0,25,0,171,0,249,0,213,0,63,0,0,0,133,0,0,0,237,0,139,0,50,0,47,0,107,0,29,0,236,0,0,0,172,0,201,0,115,0,20,0,183,0,0,0,76,0,142,0,0,0,108,0,82,0,17,0,103,0,183,0,124,0,230,0,0,0,0,0,244,0,64,0,0,0,232,0,158,0,142,0,222,0,221,0,0,0,0,0,214,0,0,0,124,0,99,0,208,0,0,0,194,0,126,0,48,0,132,0,8,0,25,0,162,0,120,0,74,0,0,0,187,0,189,0,14,0,47,0,39,0,143,0,150,0,76,0,144,0,144,0,231,0,97,0,168,0,242,0,0,0,205,0,109,0,54,0,189,0,0,0,57,0,22,0,45,0,212,0,120,0,231,0,92,0,0,0,135,0,38,0,0,0,160,0,230,0,15,0,249,0,199,0,34,0,223,0,255,0,8,0,0,0,48,0,0,0,0,0,0,0,245,0,0,0,135,0,73,0,120,0,24,0,37,0,0,0,158,0,0,0,242,0,0,0,0,0,237,0,0,0,96,0,69,0,180,0,48,0,250,0,1,0,24,0,186,0,110,0,202,0,95,0,99,0,216,0,59,0,98,0,152,0,0,0,150,0,27,0,155,0,87,0,151,0,182,0,3,0,100,0,0,0,0,0,248,0,243,0,212,0,140,0,0,0,235,0,139,0,10,0,5,0,127,0,0,0,41,0,247,0,0,0,101,0,101,0,196,0,51,0,62,0,96,0,186,0,109,0,221,0);
signal scenario_full  : scenario_type := (0,0,70,31,70,30,210,31,210,30,225,31,13,31,37,31,36,31,129,31,152,31,24,31,84,31,232,31,134,31,149,31,149,30,60,31,85,31,230,31,131,31,193,31,113,31,56,31,131,31,178,31,2,31,152,31,253,31,24,31,24,30,169,31,115,31,17,31,241,31,195,31,114,31,37,31,217,31,221,31,221,30,9,31,49,31,229,31,238,31,123,31,123,30,237,31,230,31,95,31,93,31,93,30,92,31,92,30,207,31,241,31,127,31,127,30,127,29,194,31,194,30,240,31,107,31,212,31,131,31,101,31,220,31,170,31,234,31,130,31,130,30,199,31,233,31,30,31,141,31,87,31,72,31,12,31,12,30,132,31,219,31,182,31,27,31,4,31,4,30,35,31,197,31,231,31,42,31,197,31,175,31,90,31,96,31,96,30,235,31,217,31,217,30,250,31,111,31,122,31,122,30,152,31,230,31,206,31,235,31,235,30,176,31,176,30,164,31,164,30,164,29,22,31,41,31,41,30,109,31,109,30,121,31,225,31,231,31,226,31,226,30,128,31,128,30,119,31,213,31,165,31,165,30,136,31,23,31,47,31,47,30,70,31,80,31,245,31,245,30,159,31,133,31,244,31,22,31,22,30,61,31,173,31,216,31,180,31,56,31,106,31,84,31,84,30,116,31,197,31,65,31,17,31,17,30,173,31,206,31,96,31,30,31,30,30,120,31,120,30,28,31,171,31,184,31,230,31,230,30,172,31,172,30,237,31,237,30,244,31,211,31,239,31,100,31,35,31,197,31,231,31,248,31,221,31,115,31,171,31,147,31,170,31,71,31,192,31,92,31,174,31,178,31,186,31,125,31,238,31,34,31,21,31,230,31,50,31,116,31,89,31,80,31,80,30,128,31,128,30,112,31,203,31,27,31,27,30,85,31,85,30,185,31,28,31,52,31,52,30,89,31,252,31,83,31,62,31,162,31,162,30,162,29,150,31,40,31,219,31,206,31,83,31,145,31,204,31,234,31,234,30,104,31,108,31,92,31,32,31,81,31,45,31,23,31,182,31,47,31,47,30,209,31,200,31,186,31,189,31,31,31,119,31,240,31,240,30,125,31,171,31,15,31,65,31,65,30,220,31,255,31,57,31,57,30,174,31,248,31,175,31,138,31,14,31,163,31,163,30,118,31,153,31,73,31,117,31,112,31,101,31,227,31,186,31,186,30,30,31,88,31,232,31,61,31,222,31,219,31,35,31,199,31,191,31,191,30,191,29,104,31,17,31,124,31,40,31,74,31,74,31,249,31,140,31,22,31,61,31,67,31,254,31,14,31,14,30,14,29,115,31,163,31,188,31,188,30,188,29,207,31,75,31,11,31,156,31,196,31,174,31,60,31,46,31,199,31,144,31,12,31,3,31,13,31,197,31,108,31,66,31,63,31,229,31,217,31,19,31,67,31,176,31,163,31,113,31,113,30,235,31,61,31,78,31,78,30,7,31,7,30,205,31,129,31,105,31,40,31,131,31,88,31,103,31,203,31,215,31,214,31,26,31,99,31,99,30,50,31,48,31,154,31,154,30,154,29,154,28,154,27,154,26,154,25,203,31,172,31,248,31,28,31,28,30,168,31,160,31,159,31,40,31,66,31,17,31,74,31,74,30,74,29,252,31,252,30,101,31,80,31,26,31,143,31,143,30,143,29,4,31,16,31,205,31,151,31,30,31,249,31,249,30,198,31,238,31,163,31,31,31,32,31,35,31,40,31,25,31,171,31,249,31,213,31,63,31,63,30,133,31,133,30,237,31,139,31,50,31,47,31,107,31,29,31,236,31,236,30,172,31,201,31,115,31,20,31,183,31,183,30,76,31,142,31,142,30,108,31,82,31,17,31,103,31,183,31,124,31,230,31,230,30,230,29,244,31,64,31,64,30,232,31,158,31,142,31,222,31,221,31,221,30,221,29,214,31,214,30,124,31,99,31,208,31,208,30,194,31,126,31,48,31,132,31,8,31,25,31,162,31,120,31,74,31,74,30,187,31,189,31,14,31,47,31,39,31,143,31,150,31,76,31,144,31,144,31,231,31,97,31,168,31,242,31,242,30,205,31,109,31,54,31,189,31,189,30,57,31,22,31,45,31,212,31,120,31,231,31,92,31,92,30,135,31,38,31,38,30,160,31,230,31,15,31,249,31,199,31,34,31,223,31,255,31,8,31,8,30,48,31,48,30,48,29,48,28,245,31,245,30,135,31,73,31,120,31,24,31,37,31,37,30,158,31,158,30,242,31,242,30,242,29,237,31,237,30,96,31,69,31,180,31,48,31,250,31,1,31,24,31,186,31,110,31,202,31,95,31,99,31,216,31,59,31,98,31,152,31,152,30,150,31,27,31,155,31,87,31,151,31,182,31,3,31,100,31,100,30,100,29,248,31,243,31,212,31,140,31,140,30,235,31,139,31,10,31,5,31,127,31,127,30,41,31,247,31,247,30,101,31,101,31,196,31,51,31,62,31,96,31,186,31,109,31,221,31);

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
