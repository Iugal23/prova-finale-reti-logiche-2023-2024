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

constant SCENARIO_LENGTH : integer := 597;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (189,0,0,0,95,0,0,0,139,0,143,0,70,0,246,0,40,0,126,0,126,0,229,0,230,0,162,0,223,0,172,0,124,0,45,0,249,0,73,0,133,0,199,0,140,0,240,0,153,0,113,0,137,0,36,0,32,0,77,0,233,0,130,0,109,0,47,0,203,0,183,0,210,0,62,0,210,0,91,0,60,0,168,0,0,0,47,0,0,0,9,0,71,0,125,0,133,0,130,0,168,0,2,0,2,0,106,0,129,0,0,0,169,0,160,0,157,0,28,0,81,0,17,0,58,0,218,0,54,0,0,0,226,0,236,0,0,0,0,0,142,0,178,0,199,0,220,0,236,0,44,0,157,0,45,0,94,0,231,0,136,0,106,0,241,0,171,0,127,0,48,0,176,0,213,0,89,0,180,0,135,0,153,0,135,0,35,0,79,0,28,0,195,0,224,0,0,0,176,0,85,0,0,0,63,0,55,0,151,0,0,0,0,0,117,0,28,0,0,0,74,0,0,0,80,0,0,0,176,0,0,0,24,0,0,0,115,0,0,0,243,0,0,0,9,0,28,0,109,0,83,0,51,0,24,0,201,0,56,0,51,0,227,0,37,0,215,0,16,0,207,0,178,0,229,0,254,0,203,0,23,0,243,0,155,0,0,0,0,0,116,0,15,0,15,0,130,0,0,0,73,0,154,0,82,0,75,0,66,0,31,0,29,0,117,0,0,0,182,0,0,0,198,0,190,0,216,0,155,0,131,0,0,0,86,0,177,0,42,0,234,0,243,0,0,0,251,0,106,0,0,0,168,0,48,0,0,0,79,0,171,0,190,0,168,0,129,0,169,0,84,0,201,0,140,0,35,0,228,0,116,0,84,0,160,0,0,0,12,0,218,0,85,0,109,0,135,0,0,0,224,0,0,0,126,0,5,0,165,0,106,0,203,0,208,0,85,0,178,0,169,0,226,0,203,0,121,0,48,0,0,0,90,0,235,0,0,0,131,0,64,0,75,0,203,0,167,0,182,0,228,0,212,0,12,0,197,0,157,0,0,0,22,0,213,0,0,0,0,0,0,0,165,0,228,0,0,0,17,0,115,0,251,0,0,0,0,0,0,0,48,0,205,0,84,0,197,0,145,0,123,0,24,0,16,0,0,0,69,0,238,0,148,0,0,0,214,0,125,0,147,0,33,0,206,0,0,0,0,0,198,0,65,0,129,0,0,0,200,0,231,0,220,0,16,0,189,0,128,0,147,0,44,0,88,0,188,0,88,0,175,0,188,0,17,0,0,0,0,0,0,0,237,0,79,0,0,0,218,0,198,0,0,0,209,0,22,0,189,0,17,0,123,0,177,0,25,0,0,0,157,0,0,0,164,0,224,0,0,0,0,0,114,0,118,0,123,0,190,0,29,0,0,0,43,0,76,0,227,0,189,0,199,0,0,0,0,0,125,0,217,0,158,0,209,0,143,0,78,0,0,0,139,0,123,0,227,0,182,0,186,0,251,0,0,0,85,0,43,0,15,0,71,0,222,0,116,0,171,0,143,0,137,0,123,0,0,0,147,0,41,0,0,0,21,0,103,0,174,0,14,0,0,0,163,0,250,0,206,0,177,0,0,0,188,0,248,0,160,0,72,0,149,0,64,0,57,0,52,0,146,0,159,0,0,0,96,0,92,0,130,0,180,0,129,0,253,0,212,0,52,0,33,0,167,0,69,0,0,0,0,0,0,0,106,0,32,0,89,0,219,0,156,0,145,0,235,0,36,0,188,0,0,0,167,0,36,0,113,0,28,0,0,0,0,0,0,0,18,0,47,0,125,0,0,0,180,0,193,0,41,0,204,0,141,0,59,0,99,0,0,0,50,0,223,0,138,0,77,0,52,0,60,0,40,0,214,0,61,0,211,0,122,0,241,0,7,0,112,0,97,0,144,0,0,0,30,0,104,0,20,0,161,0,2,0,176,0,39,0,83,0,208,0,65,0,225,0,84,0,190,0,0,0,223,0,64,0,116,0,160,0,63,0,174,0,0,0,0,0,112,0,153,0,0,0,112,0,0,0,0,0,173,0,168,0,95,0,91,0,250,0,96,0,0,0,33,0,62,0,179,0,107,0,41,0,158,0,10,0,251,0,133,0,181,0,239,0,0,0,116,0,0,0,83,0,227,0,150,0,143,0,105,0,0,0,197,0,0,0,50,0,155,0,191,0,0,0,110,0,155,0,161,0,0,0,235,0,117,0,0,0,186,0,0,0,0,0,20,0,231,0,0,0,119,0,207,0,219,0,6,0,0,0,183,0,132,0,0,0,0,0,159,0,251,0,0,0,0,0,193,0,21,0,125,0,254,0,143,0,109,0,17,0,250,0,117,0,0,0,0,0,134,0,192,0,5,0,156,0,242,0,148,0,158,0,9,0,44,0,164,0,59,0,0,0,101,0,241,0,134,0,151,0,231,0,111,0,59,0,83,0,19,0,51,0,0,0,176,0,87,0,35,0,94,0,116,0,53,0,68,0,111,0,228,0,220,0,8,0,172,0,221,0,96,0,57,0,70,0,171,0,140,0,55,0,0,0,220,0,99,0,186,0,0,0,10,0,45,0,78,0,105,0,2,0,98,0,191,0,0,0,206,0,159,0,10,0,8,0,0,0,71,0,181,0,236,0,0,0,0,0,174,0,106,0,126,0,58,0,0,0,41,0);
signal scenario_full  : scenario_type := (189,31,189,30,95,31,95,30,139,31,143,31,70,31,246,31,40,31,126,31,126,31,229,31,230,31,162,31,223,31,172,31,124,31,45,31,249,31,73,31,133,31,199,31,140,31,240,31,153,31,113,31,137,31,36,31,32,31,77,31,233,31,130,31,109,31,47,31,203,31,183,31,210,31,62,31,210,31,91,31,60,31,168,31,168,30,47,31,47,30,9,31,71,31,125,31,133,31,130,31,168,31,2,31,2,31,106,31,129,31,129,30,169,31,160,31,157,31,28,31,81,31,17,31,58,31,218,31,54,31,54,30,226,31,236,31,236,30,236,29,142,31,178,31,199,31,220,31,236,31,44,31,157,31,45,31,94,31,231,31,136,31,106,31,241,31,171,31,127,31,48,31,176,31,213,31,89,31,180,31,135,31,153,31,135,31,35,31,79,31,28,31,195,31,224,31,224,30,176,31,85,31,85,30,63,31,55,31,151,31,151,30,151,29,117,31,28,31,28,30,74,31,74,30,80,31,80,30,176,31,176,30,24,31,24,30,115,31,115,30,243,31,243,30,9,31,28,31,109,31,83,31,51,31,24,31,201,31,56,31,51,31,227,31,37,31,215,31,16,31,207,31,178,31,229,31,254,31,203,31,23,31,243,31,155,31,155,30,155,29,116,31,15,31,15,31,130,31,130,30,73,31,154,31,82,31,75,31,66,31,31,31,29,31,117,31,117,30,182,31,182,30,198,31,190,31,216,31,155,31,131,31,131,30,86,31,177,31,42,31,234,31,243,31,243,30,251,31,106,31,106,30,168,31,48,31,48,30,79,31,171,31,190,31,168,31,129,31,169,31,84,31,201,31,140,31,35,31,228,31,116,31,84,31,160,31,160,30,12,31,218,31,85,31,109,31,135,31,135,30,224,31,224,30,126,31,5,31,165,31,106,31,203,31,208,31,85,31,178,31,169,31,226,31,203,31,121,31,48,31,48,30,90,31,235,31,235,30,131,31,64,31,75,31,203,31,167,31,182,31,228,31,212,31,12,31,197,31,157,31,157,30,22,31,213,31,213,30,213,29,213,28,165,31,228,31,228,30,17,31,115,31,251,31,251,30,251,29,251,28,48,31,205,31,84,31,197,31,145,31,123,31,24,31,16,31,16,30,69,31,238,31,148,31,148,30,214,31,125,31,147,31,33,31,206,31,206,30,206,29,198,31,65,31,129,31,129,30,200,31,231,31,220,31,16,31,189,31,128,31,147,31,44,31,88,31,188,31,88,31,175,31,188,31,17,31,17,30,17,29,17,28,237,31,79,31,79,30,218,31,198,31,198,30,209,31,22,31,189,31,17,31,123,31,177,31,25,31,25,30,157,31,157,30,164,31,224,31,224,30,224,29,114,31,118,31,123,31,190,31,29,31,29,30,43,31,76,31,227,31,189,31,199,31,199,30,199,29,125,31,217,31,158,31,209,31,143,31,78,31,78,30,139,31,123,31,227,31,182,31,186,31,251,31,251,30,85,31,43,31,15,31,71,31,222,31,116,31,171,31,143,31,137,31,123,31,123,30,147,31,41,31,41,30,21,31,103,31,174,31,14,31,14,30,163,31,250,31,206,31,177,31,177,30,188,31,248,31,160,31,72,31,149,31,64,31,57,31,52,31,146,31,159,31,159,30,96,31,92,31,130,31,180,31,129,31,253,31,212,31,52,31,33,31,167,31,69,31,69,30,69,29,69,28,106,31,32,31,89,31,219,31,156,31,145,31,235,31,36,31,188,31,188,30,167,31,36,31,113,31,28,31,28,30,28,29,28,28,18,31,47,31,125,31,125,30,180,31,193,31,41,31,204,31,141,31,59,31,99,31,99,30,50,31,223,31,138,31,77,31,52,31,60,31,40,31,214,31,61,31,211,31,122,31,241,31,7,31,112,31,97,31,144,31,144,30,30,31,104,31,20,31,161,31,2,31,176,31,39,31,83,31,208,31,65,31,225,31,84,31,190,31,190,30,223,31,64,31,116,31,160,31,63,31,174,31,174,30,174,29,112,31,153,31,153,30,112,31,112,30,112,29,173,31,168,31,95,31,91,31,250,31,96,31,96,30,33,31,62,31,179,31,107,31,41,31,158,31,10,31,251,31,133,31,181,31,239,31,239,30,116,31,116,30,83,31,227,31,150,31,143,31,105,31,105,30,197,31,197,30,50,31,155,31,191,31,191,30,110,31,155,31,161,31,161,30,235,31,117,31,117,30,186,31,186,30,186,29,20,31,231,31,231,30,119,31,207,31,219,31,6,31,6,30,183,31,132,31,132,30,132,29,159,31,251,31,251,30,251,29,193,31,21,31,125,31,254,31,143,31,109,31,17,31,250,31,117,31,117,30,117,29,134,31,192,31,5,31,156,31,242,31,148,31,158,31,9,31,44,31,164,31,59,31,59,30,101,31,241,31,134,31,151,31,231,31,111,31,59,31,83,31,19,31,51,31,51,30,176,31,87,31,35,31,94,31,116,31,53,31,68,31,111,31,228,31,220,31,8,31,172,31,221,31,96,31,57,31,70,31,171,31,140,31,55,31,55,30,220,31,99,31,186,31,186,30,10,31,45,31,78,31,105,31,2,31,98,31,191,31,191,30,206,31,159,31,10,31,8,31,8,30,71,31,181,31,236,31,236,30,236,29,174,31,106,31,126,31,58,31,58,30,41,31);

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
