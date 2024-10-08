-- TB EXAMPLE PFRL 2023-2024

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity project_tb_903 is
end project_tb_903;

architecture project_tb_arch_903 of project_tb_903 is
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

constant SCENARIO_LENGTH : integer := 379;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (198,0,11,0,66,0,83,0,0,0,124,0,72,0,17,0,117,0,0,0,78,0,42,0,0,0,176,0,120,0,114,0,2,0,194,0,241,0,233,0,205,0,69,0,17,0,86,0,0,0,110,0,55,0,131,0,21,0,0,0,135,0,0,0,0,0,83,0,178,0,250,0,152,0,73,0,228,0,56,0,0,0,0,0,0,0,118,0,50,0,98,0,151,0,13,0,63,0,0,0,199,0,0,0,13,0,3,0,65,0,0,0,249,0,5,0,0,0,68,0,181,0,102,0,90,0,158,0,0,0,0,0,19,0,28,0,116,0,254,0,169,0,176,0,0,0,0,0,186,0,253,0,145,0,0,0,123,0,41,0,203,0,216,0,75,0,228,0,0,0,85,0,231,0,135,0,40,0,199,0,133,0,251,0,69,0,0,0,135,0,76,0,135,0,0,0,0,0,22,0,93,0,57,0,125,0,40,0,159,0,111,0,0,0,0,0,145,0,78,0,26,0,0,0,120,0,250,0,200,0,119,0,0,0,39,0,155,0,118,0,225,0,51,0,161,0,84,0,0,0,228,0,0,0,0,0,147,0,200,0,10,0,120,0,92,0,99,0,126,0,0,0,205,0,0,0,33,0,81,0,23,0,0,0,150,0,71,0,250,0,0,0,47,0,0,0,0,0,166,0,9,0,0,0,0,0,113,0,200,0,94,0,0,0,197,0,100,0,196,0,138,0,0,0,0,0,226,0,110,0,208,0,210,0,174,0,103,0,194,0,150,0,213,0,135,0,150,0,34,0,115,0,44,0,0,0,35,0,121,0,97,0,46,0,255,0,128,0,10,0,204,0,8,0,106,0,0,0,147,0,61,0,138,0,0,0,115,0,33,0,164,0,178,0,102,0,153,0,23,0,28,0,132,0,101,0,252,0,222,0,0,0,0,0,20,0,175,0,172,0,111,0,1,0,149,0,188,0,0,0,0,0,116,0,206,0,231,0,197,0,0,0,187,0,0,0,125,0,206,0,44,0,0,0,0,0,180,0,32,0,0,0,1,0,234,0,15,0,224,0,65,0,102,0,0,0,0,0,136,0,133,0,0,0,231,0,69,0,179,0,122,0,52,0,94,0,0,0,0,0,182,0,10,0,140,0,30,0,124,0,0,0,36,0,0,0,103,0,255,0,126,0,91,0,25,0,39,0,113,0,30,0,0,0,230,0,201,0,90,0,8,0,14,0,128,0,113,0,94,0,153,0,63,0,0,0,242,0,150,0,48,0,8,0,120,0,200,0,191,0,1,0,155,0,190,0,201,0,58,0,46,0,181,0,15,0,16,0,70,0,28,0,127,0,21,0,246,0,1,0,120,0,0,0,135,0,0,0,0,0,0,0,0,0,131,0,64,0,0,0,32,0,71,0,201,0,115,0,11,0,0,0,86,0,193,0,188,0,34,0,79,0,199,0,237,0,0,0,0,0,205,0,213,0,179,0,106,0,94,0,0,0,0,0,0,0,195,0,91,0,16,0,32,0,221,0,135,0,0,0,150,0,16,0,236,0,180,0,13,0,3,0,139,0,6,0,106,0,228,0,11,0,251,0,193,0,247,0,243,0,246,0,0,0,0,0,70,0,42,0,4,0,182,0,29,0,130,0,157,0,132,0,211,0,160,0,94,0,0,0,247,0,85,0,129,0,211,0,236,0,236,0,150,0,63,0,203,0);
signal scenario_full  : scenario_type := (198,31,11,31,66,31,83,31,83,30,124,31,72,31,17,31,117,31,117,30,78,31,42,31,42,30,176,31,120,31,114,31,2,31,194,31,241,31,233,31,205,31,69,31,17,31,86,31,86,30,110,31,55,31,131,31,21,31,21,30,135,31,135,30,135,29,83,31,178,31,250,31,152,31,73,31,228,31,56,31,56,30,56,29,56,28,118,31,50,31,98,31,151,31,13,31,63,31,63,30,199,31,199,30,13,31,3,31,65,31,65,30,249,31,5,31,5,30,68,31,181,31,102,31,90,31,158,31,158,30,158,29,19,31,28,31,116,31,254,31,169,31,176,31,176,30,176,29,186,31,253,31,145,31,145,30,123,31,41,31,203,31,216,31,75,31,228,31,228,30,85,31,231,31,135,31,40,31,199,31,133,31,251,31,69,31,69,30,135,31,76,31,135,31,135,30,135,29,22,31,93,31,57,31,125,31,40,31,159,31,111,31,111,30,111,29,145,31,78,31,26,31,26,30,120,31,250,31,200,31,119,31,119,30,39,31,155,31,118,31,225,31,51,31,161,31,84,31,84,30,228,31,228,30,228,29,147,31,200,31,10,31,120,31,92,31,99,31,126,31,126,30,205,31,205,30,33,31,81,31,23,31,23,30,150,31,71,31,250,31,250,30,47,31,47,30,47,29,166,31,9,31,9,30,9,29,113,31,200,31,94,31,94,30,197,31,100,31,196,31,138,31,138,30,138,29,226,31,110,31,208,31,210,31,174,31,103,31,194,31,150,31,213,31,135,31,150,31,34,31,115,31,44,31,44,30,35,31,121,31,97,31,46,31,255,31,128,31,10,31,204,31,8,31,106,31,106,30,147,31,61,31,138,31,138,30,115,31,33,31,164,31,178,31,102,31,153,31,23,31,28,31,132,31,101,31,252,31,222,31,222,30,222,29,20,31,175,31,172,31,111,31,1,31,149,31,188,31,188,30,188,29,116,31,206,31,231,31,197,31,197,30,187,31,187,30,125,31,206,31,44,31,44,30,44,29,180,31,32,31,32,30,1,31,234,31,15,31,224,31,65,31,102,31,102,30,102,29,136,31,133,31,133,30,231,31,69,31,179,31,122,31,52,31,94,31,94,30,94,29,182,31,10,31,140,31,30,31,124,31,124,30,36,31,36,30,103,31,255,31,126,31,91,31,25,31,39,31,113,31,30,31,30,30,230,31,201,31,90,31,8,31,14,31,128,31,113,31,94,31,153,31,63,31,63,30,242,31,150,31,48,31,8,31,120,31,200,31,191,31,1,31,155,31,190,31,201,31,58,31,46,31,181,31,15,31,16,31,70,31,28,31,127,31,21,31,246,31,1,31,120,31,120,30,135,31,135,30,135,29,135,28,135,27,131,31,64,31,64,30,32,31,71,31,201,31,115,31,11,31,11,30,86,31,193,31,188,31,34,31,79,31,199,31,237,31,237,30,237,29,205,31,213,31,179,31,106,31,94,31,94,30,94,29,94,28,195,31,91,31,16,31,32,31,221,31,135,31,135,30,150,31,16,31,236,31,180,31,13,31,3,31,139,31,6,31,106,31,228,31,11,31,251,31,193,31,247,31,243,31,246,31,246,30,246,29,70,31,42,31,4,31,182,31,29,31,130,31,157,31,132,31,211,31,160,31,94,31,94,30,247,31,85,31,129,31,211,31,236,31,236,31,150,31,63,31,203,31);

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
