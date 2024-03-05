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

constant SCENARIO_LENGTH : integer := 617;
    type scenario_type is array (0 to SCENARIO_LENGTH*2-1) of integer;

signal scenario_input : scenario_type := (244,0,113,0,97,0,207,0,222,0,138,0,226,0,0,0,0,0,243,0,173,0,136,0,127,0,110,0,151,0,195,0,150,0,2,0,0,0,100,0,0,0,188,0,153,0,202,0,121,0,104,0,253,0,241,0,218,0,175,0,0,0,211,0,8,0,59,0,38,0,252,0,28,0,0,0,0,0,151,0,111,0,162,0,54,0,0,0,209,0,153,0,47,0,63,0,138,0,0,0,127,0,139,0,123,0,160,0,0,0,164,0,37,0,92,0,114,0,26,0,124,0,183,0,220,0,28,0,80,0,254,0,46,0,224,0,0,0,167,0,22,0,18,0,67,0,0,0,7,0,78,0,54,0,200,0,255,0,0,0,199,0,189,0,254,0,103,0,229,0,50,0,174,0,204,0,0,0,235,0,47,0,18,0,153,0,192,0,0,0,120,0,20,0,245,0,153,0,73,0,15,0,0,0,0,0,0,0,95,0,1,0,162,0,254,0,245,0,213,0,0,0,176,0,6,0,204,0,76,0,239,0,100,0,155,0,148,0,129,0,200,0,0,0,194,0,0,0,110,0,159,0,28,0,217,0,39,0,236,0,183,0,102,0,214,0,243,0,0,0,19,0,196,0,210,0,191,0,48,0,22,0,20,0,240,0,245,0,173,0,117,0,93,0,75,0,25,0,60,0,25,0,20,0,0,0,33,0,63,0,41,0,32,0,52,0,171,0,221,0,40,0,105,0,250,0,41,0,224,0,132,0,199,0,199,0,200,0,82,0,61,0,208,0,51,0,62,0,41,0,195,0,60,0,0,0,14,0,167,0,124,0,24,0,0,0,178,0,229,0,0,0,93,0,0,0,238,0,239,0,250,0,37,0,64,0,57,0,119,0,164,0,74,0,187,0,187,0,0,0,251,0,15,0,235,0,0,0,0,0,0,0,181,0,66,0,195,0,139,0,158,0,94,0,157,0,196,0,87,0,0,0,252,0,0,0,3,0,162,0,85,0,34,0,125,0,69,0,20,0,195,0,100,0,58,0,99,0,224,0,79,0,65,0,0,0,10,0,108,0,112,0,250,0,118,0,98,0,216,0,90,0,41,0,38,0,41,0,76,0,5,0,145,0,53,0,155,0,0,0,170,0,118,0,0,0,14,0,168,0,0,0,237,0,25,0,3,0,27,0,0,0,87,0,220,0,125,0,132,0,120,0,17,0,0,0,171,0,207,0,203,0,211,0,254,0,30,0,7,0,20,0,243,0,245,0,69,0,198,0,67,0,9,0,143,0,2,0,0,0,165,0,50,0,0,0,179,0,160,0,63,0,99,0,146,0,0,0,42,0,0,0,0,0,37,0,232,0,75,0,1,0,157,0,74,0,49,0,0,0,30,0,0,0,9,0,182,0,217,0,144,0,0,0,0,0,56,0,136,0,0,0,175,0,223,0,255,0,203,0,0,0,177,0,140,0,168,0,113,0,128,0,111,0,135,0,137,0,77,0,83,0,240,0,179,0,14,0,28,0,136,0,31,0,228,0,79,0,192,0,151,0,231,0,111,0,0,0,88,0,76,0,240,0,0,0,79,0,0,0,168,0,187,0,110,0,187,0,29,0,0,0,0,0,0,0,248,0,235,0,160,0,229,0,13,0,127,0,0,0,0,0,188,0,86,0,174,0,0,0,145,0,37,0,0,0,228,0,84,0,145,0,115,0,150,0,44,0,129,0,238,0,0,0,211,0,224,0,189,0,70,0,151,0,0,0,60,0,212,0,0,0,172,0,44,0,0,0,164,0,0,0,249,0,0,0,203,0,101,0,236,0,153,0,56,0,0,0,174,0,226,0,237,0,0,0,255,0,0,0,28,0,161,0,0,0,60,0,0,0,80,0,198,0,218,0,0,0,235,0,54,0,0,0,218,0,158,0,25,0,0,0,199,0,0,0,0,0,21,0,241,0,50,0,0,0,138,0,146,0,108,0,0,0,15,0,0,0,218,0,114,0,235,0,167,0,0,0,145,0,0,0,150,0,162,0,0,0,199,0,0,0,34,0,0,0,122,0,225,0,254,0,235,0,113,0,33,0,54,0,0,0,152,0,65,0,184,0,0,0,0,0,62,0,67,0,102,0,226,0,253,0,4,0,0,0,25,0,242,0,42,0,0,0,48,0,0,0,243,0,162,0,235,0,182,0,182,0,182,0,112,0,201,0,73,0,0,0,61,0,130,0,100,0,60,0,137,0,219,0,190,0,243,0,119,0,0,0,166,0,6,0,107,0,134,0,66,0,255,0,197,0,12,0,136,0,5,0,115,0,0,0,58,0,0,0,236,0,218,0,21,0,108,0,107,0,137,0,120,0,2,0,4,0,118,0,43,0,0,0,99,0,252,0,0,0,0,0,0,0,0,0,0,0,225,0,130,0,190,0,0,0,15,0,18,0,4,0,243,0,76,0,162,0,69,0,20,0,233,0,255,0,81,0,42,0,0,0,110,0,16,0,254,0,174,0,95,0,178,0,217,0,219,0,147,0,247,0,46,0,67,0,127,0,125,0,0,0,43,0,12,0,80,0,110,0,0,0,224,0,0,0,215,0,115,0,3,0,127,0,59,0,23,0,0,0,181,0,0,0,21,0,213,0,18,0,0,0,118,0,0,0,210,0,54,0,44,0,145,0,44,0,0,0,79,0,74,0,0,0,170,0,0,0,214,0,38,0,120,0,110,0,56,0,54,0,62,0,214,0,103,0,0,0,0,0,73,0,140,0,73,0,0,0,236,0,0,0,56,0,162,0,205,0);
signal scenario_full  : scenario_type := (244,31,113,31,97,31,207,31,222,31,138,31,226,31,226,30,226,29,243,31,173,31,136,31,127,31,110,31,151,31,195,31,150,31,2,31,2,30,100,31,100,30,188,31,153,31,202,31,121,31,104,31,253,31,241,31,218,31,175,31,175,30,211,31,8,31,59,31,38,31,252,31,28,31,28,30,28,29,151,31,111,31,162,31,54,31,54,30,209,31,153,31,47,31,63,31,138,31,138,30,127,31,139,31,123,31,160,31,160,30,164,31,37,31,92,31,114,31,26,31,124,31,183,31,220,31,28,31,80,31,254,31,46,31,224,31,224,30,167,31,22,31,18,31,67,31,67,30,7,31,78,31,54,31,200,31,255,31,255,30,199,31,189,31,254,31,103,31,229,31,50,31,174,31,204,31,204,30,235,31,47,31,18,31,153,31,192,31,192,30,120,31,20,31,245,31,153,31,73,31,15,31,15,30,15,29,15,28,95,31,1,31,162,31,254,31,245,31,213,31,213,30,176,31,6,31,204,31,76,31,239,31,100,31,155,31,148,31,129,31,200,31,200,30,194,31,194,30,110,31,159,31,28,31,217,31,39,31,236,31,183,31,102,31,214,31,243,31,243,30,19,31,196,31,210,31,191,31,48,31,22,31,20,31,240,31,245,31,173,31,117,31,93,31,75,31,25,31,60,31,25,31,20,31,20,30,33,31,63,31,41,31,32,31,52,31,171,31,221,31,40,31,105,31,250,31,41,31,224,31,132,31,199,31,199,31,200,31,82,31,61,31,208,31,51,31,62,31,41,31,195,31,60,31,60,30,14,31,167,31,124,31,24,31,24,30,178,31,229,31,229,30,93,31,93,30,238,31,239,31,250,31,37,31,64,31,57,31,119,31,164,31,74,31,187,31,187,31,187,30,251,31,15,31,235,31,235,30,235,29,235,28,181,31,66,31,195,31,139,31,158,31,94,31,157,31,196,31,87,31,87,30,252,31,252,30,3,31,162,31,85,31,34,31,125,31,69,31,20,31,195,31,100,31,58,31,99,31,224,31,79,31,65,31,65,30,10,31,108,31,112,31,250,31,118,31,98,31,216,31,90,31,41,31,38,31,41,31,76,31,5,31,145,31,53,31,155,31,155,30,170,31,118,31,118,30,14,31,168,31,168,30,237,31,25,31,3,31,27,31,27,30,87,31,220,31,125,31,132,31,120,31,17,31,17,30,171,31,207,31,203,31,211,31,254,31,30,31,7,31,20,31,243,31,245,31,69,31,198,31,67,31,9,31,143,31,2,31,2,30,165,31,50,31,50,30,179,31,160,31,63,31,99,31,146,31,146,30,42,31,42,30,42,29,37,31,232,31,75,31,1,31,157,31,74,31,49,31,49,30,30,31,30,30,9,31,182,31,217,31,144,31,144,30,144,29,56,31,136,31,136,30,175,31,223,31,255,31,203,31,203,30,177,31,140,31,168,31,113,31,128,31,111,31,135,31,137,31,77,31,83,31,240,31,179,31,14,31,28,31,136,31,31,31,228,31,79,31,192,31,151,31,231,31,111,31,111,30,88,31,76,31,240,31,240,30,79,31,79,30,168,31,187,31,110,31,187,31,29,31,29,30,29,29,29,28,248,31,235,31,160,31,229,31,13,31,127,31,127,30,127,29,188,31,86,31,174,31,174,30,145,31,37,31,37,30,228,31,84,31,145,31,115,31,150,31,44,31,129,31,238,31,238,30,211,31,224,31,189,31,70,31,151,31,151,30,60,31,212,31,212,30,172,31,44,31,44,30,164,31,164,30,249,31,249,30,203,31,101,31,236,31,153,31,56,31,56,30,174,31,226,31,237,31,237,30,255,31,255,30,28,31,161,31,161,30,60,31,60,30,80,31,198,31,218,31,218,30,235,31,54,31,54,30,218,31,158,31,25,31,25,30,199,31,199,30,199,29,21,31,241,31,50,31,50,30,138,31,146,31,108,31,108,30,15,31,15,30,218,31,114,31,235,31,167,31,167,30,145,31,145,30,150,31,162,31,162,30,199,31,199,30,34,31,34,30,122,31,225,31,254,31,235,31,113,31,33,31,54,31,54,30,152,31,65,31,184,31,184,30,184,29,62,31,67,31,102,31,226,31,253,31,4,31,4,30,25,31,242,31,42,31,42,30,48,31,48,30,243,31,162,31,235,31,182,31,182,31,182,31,112,31,201,31,73,31,73,30,61,31,130,31,100,31,60,31,137,31,219,31,190,31,243,31,119,31,119,30,166,31,6,31,107,31,134,31,66,31,255,31,197,31,12,31,136,31,5,31,115,31,115,30,58,31,58,30,236,31,218,31,21,31,108,31,107,31,137,31,120,31,2,31,4,31,118,31,43,31,43,30,99,31,252,31,252,30,252,29,252,28,252,27,252,26,225,31,130,31,190,31,190,30,15,31,18,31,4,31,243,31,76,31,162,31,69,31,20,31,233,31,255,31,81,31,42,31,42,30,110,31,16,31,254,31,174,31,95,31,178,31,217,31,219,31,147,31,247,31,46,31,67,31,127,31,125,31,125,30,43,31,12,31,80,31,110,31,110,30,224,31,224,30,215,31,115,31,3,31,127,31,59,31,23,31,23,30,181,31,181,30,21,31,213,31,18,31,18,30,118,31,118,30,210,31,54,31,44,31,145,31,44,31,44,30,79,31,74,31,74,30,170,31,170,30,214,31,38,31,120,31,110,31,56,31,54,31,62,31,214,31,103,31,103,30,103,29,73,31,140,31,73,31,73,30,236,31,236,30,56,31,162,31,205,31);

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
