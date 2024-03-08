-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_24 is
end project_tb_24;

architecture project_tb_arch_24 of project_tb_24 is
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

constant SCENARIO_LENGTH : integer := 449;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (200,0,219,0,17,0,158,0,27,0,70,0,250,0,0,0,77,0,41,0,132,0,0,0,113,0,205,0,0,0,102,0,0,0,206,0,187,0,64,0,217,0,210,0,0,0,149,0,183,0,111,0,132,0,55,0,216,0,144,0,87,0,13,0,231,0,0,0,139,0,126,0,0,0,54,0,84,0,190,0,0,0,189,0,212,0,10,0,125,0,0,0,109,0,88,0,18,0,33,0,107,0,0,0,115,0,106,0,113,0,66,0,64,0,112,0,0,0,250,0,0,0,88,0,255,0,0,0,195,0,142,0,16,0,64,0,71,0,76,0,225,0,15,0,213,0,0,0,202,0,177,0,105,0,90,0,0,0,218,0,0,0,151,0,67,0,240,0,198,0,72,0,29,0,180,0,0,0,32,0,249,0,31,0,0,0,185,0,32,0,96,0,59,0,146,0,192,0,4,0,110,0,87,0,77,0,0,0,173,0,171,0,40,0,77,0,148,0,0,0,199,0,87,0,160,0,248,0,32,0,91,0,9,0,223,0,100,0,93,0,21,0,66,0,177,0,76,0,95,0,226,0,6,0,128,0,130,0,114,0,237,0,0,0,26,0,218,0,0,0,84,0,214,0,9,0,123,0,194,0,152,0,87,0,89,0,209,0,119,0,0,0,0,0,162,0,0,0,34,0,121,0,47,0,224,0,65,0,0,0,0,0,178,0,60,0,0,0,216,0,162,0,110,0,253,0,0,0,208,0,197,0,164,0,172,0,102,0,173,0,120,0,26,0,0,0,105,0,196,0,16,0,122,0,229,0,175,0,187,0,48,0,185,0,65,0,95,0,77,0,241,0,0,0,113,0,58,0,105,0,70,0,117,0,74,0,0,0,0,0,180,0,158,0,132,0,51,0,99,0,130,0,150,0,149,0,199,0,228,0,70,0,0,0,0,0,102,0,4,0,194,0,93,0,0,0,0,0,207,0,0,0,172,0,135,0,25,0,0,0,173,0,104,0,86,0,163,0,210,0,203,0,177,0,137,0,62,0,207,0,34,0,189,0,38,0,202,0,204,0,121,0,32,0,90,0,39,0,114,0,27,0,109,0,10,0,0,0,27,0,165,0,201,0,52,0,110,0,0,0,193,0,93,0,0,0,93,0,122,0,65,0,57,0,52,0,62,0,121,0,194,0,91,0,0,0,75,0,33,0,99,0,249,0,212,0,0,0,0,0,14,0,250,0,241,0,13,0,201,0,249,0,0,0,28,0,59,0,30,0,81,0,12,0,78,0,77,0,80,0,149,0,0,0,182,0,189,0,126,0,94,0,104,0,0,0,193,0,36,0,0,0,245,0,126,0,109,0,235,0,238,0,158,0,138,0,0,0,23,0,87,0,72,0,195,0,80,0,52,0,123,0,112,0,39,0,198,0,144,0,156,0,0,0,8,0,108,0,232,0,44,0,65,0,230,0,134,0,143,0,80,0,248,0,191,0,0,0,13,0,110,0,14,0,77,0,145,0,110,0,141,0,32,0,220,0,125,0,12,0,155,0,0,0,10,0,18,0,0,0,234,0,94,0,84,0,231,0,22,0,106,0,0,0,127,0,122,0,0,0,98,0,145,0,110,0,50,0,213,0,0,0,26,0,97,0,150,0,229,0,144,0,98,0,0,0,154,0,56,0,218,0,243,0,251,0,61,0,217,0,0,0,108,0,174,0,144,0,48,0,236,0,0,0,132,0,23,0,0,0,181,0,10,0,105,0,0,0,36,0,35,0,116,0,38,0,198,0,0,0,0,0,0,0,210,0,0,0,119,0,0,0,129,0,49,0,0,0,100,0,72,0,0,0,22,0,113,0,0,0,0,0,113,0,0,0,148,0,179,0,217,0,76,0,31,0,0,0,203,0,189,0,123,0,0,0,0,0,250,0,94,0,0,0,196,0,144,0,90,0,0,0,234,0,0,0,177,0,164,0,183,0,88,0,151,0,0,0,187,0,154,0,0,0,56,0,71,0,180,0,0,0,214,0,167,0,54,0);
signal scenario_full  : scenario_type := (200,31,219,31,17,31,158,31,27,31,70,31,250,31,250,30,77,31,41,31,132,31,132,30,113,31,205,31,205,30,102,31,102,30,206,31,187,31,64,31,217,31,210,31,210,30,149,31,183,31,111,31,132,31,55,31,216,31,144,31,87,31,13,31,231,31,231,30,139,31,126,31,126,30,54,31,84,31,190,31,190,30,189,31,212,31,10,31,125,31,125,30,109,31,88,31,18,31,33,31,107,31,107,30,115,31,106,31,113,31,66,31,64,31,112,31,112,30,250,31,250,30,88,31,255,31,255,30,195,31,142,31,16,31,64,31,71,31,76,31,225,31,15,31,213,31,213,30,202,31,177,31,105,31,90,31,90,30,218,31,218,30,151,31,67,31,240,31,198,31,72,31,29,31,180,31,180,30,32,31,249,31,31,31,31,30,185,31,32,31,96,31,59,31,146,31,192,31,4,31,110,31,87,31,77,31,77,30,173,31,171,31,40,31,77,31,148,31,148,30,199,31,87,31,160,31,248,31,32,31,91,31,9,31,223,31,100,31,93,31,21,31,66,31,177,31,76,31,95,31,226,31,6,31,128,31,130,31,114,31,237,31,237,30,26,31,218,31,218,30,84,31,214,31,9,31,123,31,194,31,152,31,87,31,89,31,209,31,119,31,119,30,119,29,162,31,162,30,34,31,121,31,47,31,224,31,65,31,65,30,65,29,178,31,60,31,60,30,216,31,162,31,110,31,253,31,253,30,208,31,197,31,164,31,172,31,102,31,173,31,120,31,26,31,26,30,105,31,196,31,16,31,122,31,229,31,175,31,187,31,48,31,185,31,65,31,95,31,77,31,241,31,241,30,113,31,58,31,105,31,70,31,117,31,74,31,74,30,74,29,180,31,158,31,132,31,51,31,99,31,130,31,150,31,149,31,199,31,228,31,70,31,70,30,70,29,102,31,4,31,194,31,93,31,93,30,93,29,207,31,207,30,172,31,135,31,25,31,25,30,173,31,104,31,86,31,163,31,210,31,203,31,177,31,137,31,62,31,207,31,34,31,189,31,38,31,202,31,204,31,121,31,32,31,90,31,39,31,114,31,27,31,109,31,10,31,10,30,27,31,165,31,201,31,52,31,110,31,110,30,193,31,93,31,93,30,93,31,122,31,65,31,57,31,52,31,62,31,121,31,194,31,91,31,91,30,75,31,33,31,99,31,249,31,212,31,212,30,212,29,14,31,250,31,241,31,13,31,201,31,249,31,249,30,28,31,59,31,30,31,81,31,12,31,78,31,77,31,80,31,149,31,149,30,182,31,189,31,126,31,94,31,104,31,104,30,193,31,36,31,36,30,245,31,126,31,109,31,235,31,238,31,158,31,138,31,138,30,23,31,87,31,72,31,195,31,80,31,52,31,123,31,112,31,39,31,198,31,144,31,156,31,156,30,8,31,108,31,232,31,44,31,65,31,230,31,134,31,143,31,80,31,248,31,191,31,191,30,13,31,110,31,14,31,77,31,145,31,110,31,141,31,32,31,220,31,125,31,12,31,155,31,155,30,10,31,18,31,18,30,234,31,94,31,84,31,231,31,22,31,106,31,106,30,127,31,122,31,122,30,98,31,145,31,110,31,50,31,213,31,213,30,26,31,97,31,150,31,229,31,144,31,98,31,98,30,154,31,56,31,218,31,243,31,251,31,61,31,217,31,217,30,108,31,174,31,144,31,48,31,236,31,236,30,132,31,23,31,23,30,181,31,10,31,105,31,105,30,36,31,35,31,116,31,38,31,198,31,198,30,198,29,198,28,210,31,210,30,119,31,119,30,129,31,49,31,49,30,100,31,72,31,72,30,22,31,113,31,113,30,113,29,113,31,113,30,148,31,179,31,217,31,76,31,31,31,31,30,203,31,189,31,123,31,123,30,123,29,250,31,94,31,94,30,196,31,144,31,90,31,90,30,234,31,234,30,177,31,164,31,183,31,88,31,151,31,151,30,187,31,154,31,154,30,56,31,71,31,180,31,180,30,214,31,167,31,54,31);

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
